"""Exercise installer failure paths with temporary files and stubbed downloads."""

from pathlib import Path
import hashlib
import json
import os
import plistlib
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parent.parent


class MaintenanceTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="dotfiles-test-")
        self.addCleanup(self.temporary.cleanup)
        self.fixture = Path(self.temporary.name)
        self.env = dict(os.environ, FIXTURE=str(self.fixture))

    def bash(self, script, *, stdin=None):
        return subprocess.run(
            ["bash", "-c", script, "test", str(ROOT)],
            env=self.env, cwd=ROOT, input=stdin, text=True, capture_output=True,
        )

    def assert_success(self, result):
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def deja(self, *, installed=False, update=False):
        self.env.update(ZDOTDIR=str(self.fixture))
        return self.bash('''
            source "$1/scripts/install-extras.sh"
            have() { return ''' + ("0" if installed else "1") + '''; }
            install_deja_binary() { echo install >> "$FIXTURE/events"; }
            deja() { printf '%s\\n' "$*" >> "$FIXTURE/events"; }
            update_extras=''' + ("1" if update else "0") + '''
            install_deja
        ''')

    def test_new_deja_without_history_succeeds(self):
        result = self.deja()
        self.assert_success(result)
        self.assertIn("skipping Deja import", result.stdout)
        self.assertEqual((self.fixture / "events").read_text(), "install\n")

    def test_new_deja_imports_existing_history(self):
        (self.fixture / ".zsh_history").write_text("git status\n")
        self.assert_success(self.deja())
        self.assertIn("import --file", (self.fixture / "events").read_text())

    def test_bootstrap_skips_existing_deja(self):
        self.assert_success(self.deja(installed=True))
        self.assertFalse((self.fixture / "events").exists())

    def test_deja_update_does_not_reimport_history(self):
        (self.fixture / ".zsh_history").write_text("git status\n")
        self.assert_success(self.deja(installed=True, update=True))
        self.assertEqual((self.fixture / "events").read_text(), "install\n")

    def touch_id(self, text):
        result = self.bash(
            'source "$1/scripts/setup-touch-id.sh"; render_touch_id_config', stdin=text,
        )
        self.assert_success(result)
        return result.stdout

    def test_touch_id_preserves_custom_rules_and_is_idempotent(self):
        original = "# Local rules\n#auth sufficient pam_tid.so\nauth optional custom.so\n"
        enabled = self.touch_id(original)
        self.assertEqual(enabled, original.replace("#auth", "auth"))
        self.assertEqual(self.touch_id(enabled), enabled)

    def test_touch_id_keeps_existing_enabled_entry(self):
        original = "#auth sufficient pam_tid.so\nauth sufficient pam_tid.so reuse\n"
        self.assertEqual(self.touch_id(original), original)

    def test_touch_id_adds_a_missing_entry_once(self):
        enabled = self.touch_id("# Custom configuration\n")
        self.assertEqual(enabled.count("pam_tid.so"), 1)
        self.assertEqual(self.touch_id(enabled), enabled)

    def completion_fixture(self, failure=""):
        directory = self.fixture / "bin"
        directory.mkdir()
        source = self.fixture / "zoxide/completions"
        source.mkdir(parents=True)
        (source / "_zoxide").write_text("# fresh zoxide\n")
        stub = '''#!/usr/bin/env bash
set -eu
name="${0##*/}"
if [[ "$name" == "$FAIL_GENERATOR" ]]; then
  echo 'partial output'
  exit 1
fi
if [[ "$name" == mise && "$1" == where ]]; then
  echo "$FIXTURE/zoxide"
else
  echo "# fresh $name"
fi
'''
        for name in ["mise", "gh", "starship", "rg", "bat"]:
            executable = directory / name
            executable.write_text(stub)
            executable.chmod(0o755)
        self.env.update(
            PATH=str(directory) + os.pathsep + os.environ["PATH"],
            XDG_CACHE_HOME=str(self.fixture / "cache"), FAIL_GENERATOR=failure,
        )
        target = self.fixture / "cache/zsh/generated-completions"
        target.mkdir(parents=True)
        for name in ["mise", "gh", "starship", "zoxide", "rg", "bat"]:
            (target / f"_{name}").write_text(f"# old {name}\n")
        return target

    def test_failed_generator_preserves_all_completions(self):
        target = self.completion_fixture(failure="gh")
        before = {p.name: p.read_text() for p in target.iterdir()}
        result = self.bash('bash "$1/scripts/completions.sh"')
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual({p.name: p.read_text() for p in target.iterdir()}, before)

    def test_successful_generation_replaces_completions(self):
        target = self.completion_fixture()
        self.assert_success(self.bash('bash "$1/scripts/completions.sh"'))
        self.assertEqual(len(list(target.iterdir())), 6)
        for path in target.iterdir():
            self.assertIn("# fresh", path.read_text())

    def tinycast(self, *, fail_replacement=False, bad_digest=False, running=False):
        app = self.fixture / "Applications/Tinycast.app"
        (app / "Contents").mkdir(parents=True)
        (app / "Contents/Info.plist").write_bytes(plistlib.dumps({"CFBundleShortVersionString": "1.0.0"}))
        (app / "old-only").write_text("previous app")
        digest = "0" * 64 if bad_digest else hashlib.sha256(b"download").hexdigest()
        release = {"tag_name": "v2.0.0", "assets": [{
            "name": "Tinycast-Universal-2.0.0.dmg",
            "browser_download_url": "https://example.invalid/Tinycast.dmg",
            "digest": "sha256:" + digest,
        }]}
        (self.fixture / "release.json").write_text(json.dumps(release))
        self.env.update(FAIL_REPLACEMENT=str(int(fail_replacement)), APP_RUNNING=str(int(running)))
        result = self.bash('''
            source "$1/scripts/install-extras.sh"
            update_extras=1
            curl() {
              while [[ $# -gt 0 ]]; do
                if [[ "$1" == -o ]]; then
                  printf download > "$2"
                  return
                fi
                shift
              done
              cat "$FIXTURE/release.json"
            }
            pgrep() { [[ "$APP_RUNNING" == 1 ]]; }
            hdiutil() { return 0; }
            ditto() { mkdir -p "$2"; echo new > "$2/new-only"; }
            xattr() { return 0; }
            mv() {
              if [[ "$FAIL_REPLACEMENT" == 1 && "$1" == */.Tinycast.*/Tinycast.app ]]; then
                return 1
              fi
              command mv "$@"
            }
            install_tinycast "$FIXTURE/Applications/Tinycast.app"
        ''')
        return app, result

    def test_tinycast_update_replaces_old_bundle(self):
        app, result = self.tinycast()
        self.assert_success(result)
        self.assertTrue((app / "new-only").exists())
        self.assertFalse((app / "old-only").exists())
        self.assertEqual(list(app.parent.iterdir()), [app])

    def test_tinycast_failed_replacement_restores_old_app(self):
        app, result = self.tinycast(fail_replacement=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((app / "old-only").read_text(), "previous app")
        self.assertEqual(list(app.parent.iterdir()), [app])

    def test_tinycast_bad_download_keeps_existing_app(self):
        app, result = self.tinycast(bad_digest=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertTrue((app / "old-only").exists())

    def test_tinycast_running_app_is_not_replaced(self):
        app, result = self.tinycast(running=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Quit Tinycast", result.stderr)
        self.assertTrue((app / "old-only").exists())

    def test_doctor_reports_failed_update_without_applying_repairs(self):
        result = self.bash('''
            source "$1/scripts/doctor.sh"
            mise() {
              [[ "$MISE_SELF_UPDATE_AUTO" == false && "$MISE_AUTO_INSTALL" == false ]] || return 99
              case "$*" in
                doctor | "bootstrap status --missing") return 0 ;;
                *) echo "Unexpected mise command: $*"; return 99 ;;
              esac
            }
            command() { [[ "$1" == -v ]]; }
            hx() { return 0; }
            uname() { echo Darwin; }
            agent_socket_exists() { return 0; }
            launchctl() {
              case "$2" in
                */dev.mise.mise-tool-update) echo 'last exit code = 0' ;;
                */dev.mise.mise-package-update) echo 'last exit code = 78' ;;
                *) return 99 ;;
              esac
            }
            main
        ''')
        self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
        self.assertIn("dev.mise.mise-package-update last exited with status 78", result.stdout)
        self.assertIn("1 checks need attention", result.stderr)
        self.assertNotIn("Unexpected mise command", result.stdout)

    def test_doctor_reports_unloaded_update_agent(self):
        result = self.bash('''
            source "$1/scripts/doctor.sh"
            launchctl() { return 1; }
            update_agent dev.mise.mise-tool-update
        ''')
        self.assertEqual(result.returncode, 1)
        self.assertIn("not loaded", result.stdout)


if __name__ == "__main__":
    unittest.main()
