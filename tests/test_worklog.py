import argparse
import importlib.util
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('worklog', Path(__file__).parents[1] / 'skills/cerebro-postear/scripts/worklog.py')
w = importlib.util.module_from_spec(spec)
spec.loader.exec_module(w)


class WorklogTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name).resolve()
        self.memory = 'each_one/ana/sessions/tarea.md'
        note = self.root / self.memory
        note.parent.mkdir(parents=True)
        note.write_text('Memoria')
        self.entry = self.root / 'entry.json'
        self.entry.write_text(json.dumps({'summary': 'Resultado', 'validation': 'Build verificado', 'pr': 'https://github.com/team/code/pull/1'}))
        self.args = argparse.Namespace(participant='ana', agent='codex', task='tarea', project='demo', memory=self.memory, entry=str(self.entry), dry_run=False)
        self.data = {'project': 'demo', 'brain_repo': 'team/brain', 'code_repos': ['team/code'], 'issue': 1}
        self.pr = {'merged': True, 'state': 'closed', 'merge_commit_sha': 'a'*40, 'head': {'sha': 'b'*40}}

    def test_merged_post_and_retry(self):
        def fake(endpoint, method='GET', data=None):
            if '/pulls/' in endpoint:
                return self.pr
            if method == 'POST':
                self.body = data['body']
                return {'html_url': 'https://github.com/team/brain/issues/1#issuecomment-9'}
            return {'state': 'open'}
        with patch.object(w, 'api', side_effect=fake), patch.object(w, 'pages', return_value=[]):
            result = w.post(self.args, self.root, self.data)
        self.assertEqual(result['status'], 'integrado')
        with patch.object(w, 'api', side_effect=fake) as api, patch.object(w, 'pages', return_value=[{'body': self.body, 'html_url': result['url']}]):
            self.assertTrue(w.post(self.args, self.root, self.data)['duplicate'])
            self.assertTrue(all((len(c.args) < 2 or c.args[1] != 'POST') for c in api.call_args_list))

    def test_open_pr_is_not_integrated_and_dry_run_does_not_post(self):
        self.args.dry_run = True
        self.pr.update(merged=False, state='open')
        with patch.object(w, 'api', return_value=self.pr) as api:
            result = w.post(self.args, self.root, self.data)
        self.assertEqual(result['status'], 'en-revision')
        self.assertEqual(api.call_count, 1)

    def test_rejects_closed_unmerged_and_foreign_memory(self):
        self.pr.update(merged=False)
        with patch.object(w, 'api', return_value=self.pr):
            with self.assertRaises(ValueError):
                w.post(self.args, self.root, self.data)
        self.args.memory = '../outside.md'
        with self.assertRaises(ValueError):
            w.post(self.args, self.root, self.data)

    def test_document_without_pr_has_explicit_status(self):
        self.entry.write_text(json.dumps({'summary': 'Investigación', 'validation': 'Fuentes revisadas', 'artifact': 'https://github.com/team/brain/commit/'+'a'*40, 'no_pr_reason': 'Nota del cerebro publicada directamente'}))
        self.args.dry_run = True
        with patch.object(w, 'api', return_value={'sha': 'a'*40}):
            self.assertEqual(w.post(self.args, self.root, self.data)['status'], 'entregado-sin-pr')

    def test_rejects_unconfigured_repo(self):
        self.data['code_repos'] = ['other/code']
        with patch.object(w, 'api') as api, self.assertRaises(ValueError):
            w.post(self.args, self.root, self.data)
        api.assert_not_called()

    def test_read_bounds_and_warns_truncation(self):
        comments = []
        for n in range(12):
            entry = {'project': 'demo', 'summary': str(n), 'participant': 'ana', 'status': 'integrado'}
            comments.append({'body': '<!-- cerebro-entry:v1 key=x -->\n```json\n'+json.dumps(entry)+'\n```', 'html_url': str(n), 'updated_at': f'2026-11-06T00:00:{n:02}Z'})
        comments.append({'body': 'Comentario manual', 'html_url': 'manual'})
        args = argparse.Namespace(project='demo', since='2026-11-06T00:00:00Z', participant=None, limit=10)
        with patch.object(w, 'pages', return_value=comments):
            result = w.read(args, self.data)
        self.assertTrue(result['truncated'])
        self.assertEqual(result['matched'], 12)
        self.assertEqual(result['entries'][0]['summary'], '2')

    def test_pagination(self):
        with patch.object(w, 'api', side_effect=[list(range(100)), [100]]) as api:
            self.assertEqual(len(list(w.pages('repos/team/brain/issues?state=all'))), 101)
        self.assertIn('&per_page=100&page=2', api.call_args.args[0])

    def test_init_reuses_remote_issue(self):
        args = argparse.Namespace(project='demo', repo='team/brain', code_repo=['team/code'])
        issue = {'number': 7, 'body': '<!-- cerebro-worklog:v1 project=demo -->', 'html_url': 'issue-url'}
        with patch.object(w, 'api', return_value={'private': True, 'has_issues': True}) as api, patch.object(w, 'pages', return_value=[issue]):
            self.assertEqual(w.init(args, self.root)['url'], 'issue-url')
        self.assertEqual(api.call_count, 1)
        self.assertEqual(json.loads((self.root/'.brain/worklogs/demo.json').read_text())['issue'], 7)
        with patch.object(w, 'api') as api:
            self.assertTrue(w.init(args, self.root)['configured'])
        api.assert_not_called()


if __name__ == '__main__':
    unittest.main()
