#!/usr/bin/env python3
"""Bitácora en GitHub Issues. Python 3 + gh, sin dependencias ni credenciales propias."""
import argparse
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path
from urllib.parse import urlencode


def api(endpoint, method='GET', data=None):
    cmd = ['gh', 'api', endpoint, '--method', method]
    if data is not None:
        cmd += ['--input', '-']
    result = subprocess.run(cmd, input=json.dumps(data) if data is not None else None,
                            text=True, capture_output=True, check=True)
    return json.loads(result.stdout)


def pages(endpoint):
    page = 1
    while True:
        sep = '&' if '?' in endpoint else '?'
        batch = api(f'{endpoint}{sep}per_page=100&page={page}')
        yield from batch
        if len(batch) < 100:
            return
        page += 1


def slug(value):
    if not re.fullmatch(r'[a-z0-9][a-z0-9-]{0,63}', value):
        raise ValueError('Identificador inválido: usar minúsculas, números y guiones.')
    return value


def repo(value):
    if not re.fullmatch(r'[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+', value):
        raise ValueError('Repositorio inválido: usar owner/repo.')
    return value


def config(root, project):
    path = root / '.brain' / 'worklogs' / f'{slug(project)}.json'
    data = json.loads(path.read_text())
    repo(data['brain_repo'])
    for name in data['code_repos']:
        repo(name)
    if data['project'] != project or not isinstance(data['issue'], int) or data['issue'] < 1:
        raise ValueError('Configuración de bitácora inválida.')
    return path, data


def init(args, root):
    path = root / '.brain' / 'worklogs' / f'{args.project}.json'
    if path.exists():
        _, data = config(root, args.project)
        if data['brain_repo'] != args.repo or data['code_repos'] != sorted(set(args.code_repo)):
            raise ValueError('Ya existe otra configuración; revisar sin sobrescribirla.')
        return {'configured': True, 'issue': data['issue'], 'brain_repo': data['brain_repo']}
    metadata = api(f'repos/{args.repo}')
    if not metadata['private']:
        raise ValueError('El cerebro debe ser privado.')
    if not metadata['has_issues']:
        raise ValueError('Habilitar Issues en el repositorio del cerebro.')
    marker = f'<!-- cerebro-worklog:v1 project={args.project} -->'
    # Reutiliza un Issue preexistente incluso si se perdió la configuración local.
    matches = [i for i in pages(f'repos/{args.repo}/issues?state=all')
               if not i.get('pull_request') and marker in (i.get('body') or '')]
    if len(matches) > 1:
        raise ValueError('Hay varias bitácoras del proyecto; resolver explícitamente.')
    issue = matches[0] if matches else api(f'repos/{args.repo}/issues', 'POST', {
        'title': f'[Trabajos] {args.project}',
        'body': marker + '\n\nBitácora del equipo: una entrada por entrega y agente.\n\n'
                'Cada entrada identifica participante, agente, tarea, PR y commit, validación y memoria. '
                'Una PR abierta queda en revisión; sólo una PR merged se registra como integrada. '
                'El estado vigente y las decisiones viven en el cerebro; este Issue conserva el historial.\n\n'
                'Consultar desde cerebro-leer y publicar desde cerebro-cierre / cerebro-postear. '
                'No cerrar este Issue al integrar una PR ni pegar conversaciones o secretos.'})
    data = {'version': 1, 'project': args.project, 'brain_repo': args.repo,
            'issue': issue['number'], 'code_repos': sorted(set(args.code_repo))}
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2) + '\n')
    return {'config': str(path), 'url': issue['html_url']}


def post(args, root, data):
    root = root.resolve()
    participant = slug(args.participant)
    if not (root / 'each_one' / participant).is_dir():
        raise ValueError('Participante no incorporado: ejecutar cerebro-setup antes de publicar.')
    note = (root / args.memory).resolve()
    relative = note.relative_to(root)
    if relative.parts[:3] != ('each_one', participant, 'sessions') or not note.is_file():
        raise ValueError('La memoria debe ser una sesión existente del participante, dentro del cerebro.')
    entry = json.loads(Path(args.entry).read_text())
    for field, limit in [('summary', 600), ('validation', 900)]:
        if not isinstance(entry.get(field), str) or not entry[field].strip() or len(entry[field]) > limit:
            raise ValueError(f'{field}: texto requerido, máximo {limit} caracteres.')
    evidence = entry.get('pr') or entry.get('artifact', '')
    match = re.fullmatch(r'https://github.com/([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)/pull/([1-9][0-9]*)', evidence)
    if match:
        if match[1] not in data['code_repos']:
            raise ValueError('PR fuera de los code_repos configurados.')
        pr = api(f'repos/{match[1]}/pulls/{match[2]}')
        status = 'integrado' if pr['merged'] else 'en-revision' if pr['state'] == 'open' else 'cerrado-sin-integrar'
        if status == 'cerrado-sin-integrar':
            raise ValueError('Una PR cerrada sin merge no es una entrega terminada.')
        commit = pr['merge_commit_sha'] if pr['merged'] else pr['head']['sha']
    else:
        artifact = re.fullmatch(r'https://github.com/([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)/commit/([a-f0-9]{40})', evidence)
        if not artifact or artifact[1] not in data['code_repos'] + [data['brain_repo']]:
            raise ValueError('Se requiere PR o URL de commit completo en un repo configurado.')
        if not isinstance(entry.get('no_pr_reason'), str) or not 1 <= len(entry['no_pr_reason']) <= 300:
            raise ValueError('Sin PR, explicar no_pr_reason (máximo 300 caracteres).')
        verified = api(f'repos/{artifact[1]}/commits/{artifact[2]}')
        commit, status = verified['sha'], 'entregado-sin-pr'
    key = hashlib.sha256(f'{args.project}:{participant}:{args.agent}:{args.task}:{evidence}:{commit}:{status}'.encode()).hexdigest()[:24]
    marker = f'<!-- cerebro-entry:v1 key={key} -->'
    payload = {'key': key, 'project': args.project, 'participant': participant,
               'agent': args.agent, 'task': args.task, 'status': status, 'pr': evidence if match else None, 'artifact': None if match else evidence,
               'commit': commit, 'no_pr_reason': entry.get('no_pr_reason'), 'memory': relative.as_posix(),
               'summary': entry['summary'], 'validation': entry['validation']}
    body = marker + '\n' + '```json\n' + json.dumps(payload, ensure_ascii=False, indent=2) + '\n```'
    endpoint = f"repos/{data['brain_repo']}/issues/{data['issue']}/comments"
    if args.dry_run:
        return {'dry_run': True, 'body': body, 'status': status}
    issue = api(f"repos/{data['brain_repo']}/issues/{data['issue']}")
    if issue['state'] != 'open':
        raise ValueError('La bitácora está cerrada; revisarla antes de publicar.')
    for comment in pages(endpoint):
        if marker in (comment.get('body') or ''):
            return {'duplicate': True, 'url': comment['html_url'], 'status': status}
    # No reintentar automáticamente un POST ambiguo. Reejecutar consulta la clave primero.
    comment = api(endpoint, 'POST', {'body': body})
    return {'url': comment['html_url'], 'status': status, 'key': key}


def read(args, data):
    endpoint = f"repos/{data['brain_repo']}/issues/{data['issue']}/comments"
    if args.since:
        endpoint += '?' + urlencode({'since': args.since})
    entries = []
    for comment in pages(endpoint):
        body = comment.get('body') or ''
        if not body.startswith('<!-- cerebro-entry:v1 '):
            continue
        try:
            entry = json.loads(body.split('```json\n', 1)[1].rsplit('\n```', 1)[0])
        except (ValueError, IndexError):
            continue
        if not isinstance(entry, dict) or entry.get('project') != args.project:
            continue
        if args.participant and entry.get('participant') != args.participant:
            continue
        entries.append({'participant': entry.get('participant'), 'agent': entry.get('agent'),
                        'task': entry.get('task'), 'status_at_post': entry.get('status'),
                        'summary': str(entry.get('summary', ''))[:600], 'pr': entry.get('pr'), 'artifact': entry.get('artifact'),
                        'memory': entry.get('memory'), 'url': comment['html_url'],
                        'updated_at': comment['updated_at']})
    entries.sort(key=lambda e: (e['updated_at'], e['url']))
    # since es explícito, no se avanza un cursor silenciosamente ni se omiten entradas sin avisar.
    return {'entries': entries[-args.limit:], 'matched': len(entries),
            'truncated': len(entries) > args.limit,
            'note': 'Estado observado al publicar. Consultar la PR para verificar su estado actual.'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', required=True, type=Path)
    parser.add_argument('--project', required=True, type=slug)
    sub = parser.add_subparsers(dest='command', required=True)
    start = sub.add_parser('init')
    start.add_argument('--repo', required=True, type=repo)
    start.add_argument('--code-repo', action='append', required=True, type=repo)
    publish = sub.add_parser('post')
    publish.add_argument('--participant', required=True, type=slug)
    publish.add_argument('--agent', required=True, type=slug)
    publish.add_argument('--task', required=True, type=slug)
    publish.add_argument('--entry', required=True)
    publish.add_argument('--memory', required=True)
    publish.add_argument('--dry-run', action='store_true')
    sub.add_parser('doctor')
    listing = sub.add_parser('read')
    listing.add_argument('--since', help='ISO UTC, por ejemplo 2026-11-06T00:00:00Z')
    listing.add_argument('--participant', type=slug)
    listing.add_argument('--limit', type=int, default=10)
    args = parser.parse_args()
    root = args.root.resolve()
    if not (root / '.brain' / 'brain-config.yaml').is_file():
        raise ValueError('No es un cerebro compartido configurado.')
    if args.command == 'init':
        result = init(args, root)
    else:
        _, data = config(root, args.project)
        if args.command == 'read' and not 1 <= args.limit <= 50:
            raise ValueError('limit debe estar entre 1 y 50.')
        if args.command == 'doctor':
            metadata = api(f"repos/{data['brain_repo']}")
            issue = api(f"repos/{data['brain_repo']}/issues/{data['issue']}")
            result = {'private': metadata['private'], 'issues_enabled': metadata['has_issues'],
                      'can_push': metadata.get('permissions', {}).get('push', False),
                      'issue_open': issue['state'] == 'open', 'url': issue['html_url']}
            result['ready'] = all(result[k] for k in ('private', 'issues_enabled', 'can_push', 'issue_open'))
        else:
            result = post(args, root, data) if args.command == 'post' else read(args, data)
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, OSError, subprocess.CalledProcessError) as exc:
        print(f'No se completó la operación: {exc}', file=sys.stderr)
        sys.exit(1)
