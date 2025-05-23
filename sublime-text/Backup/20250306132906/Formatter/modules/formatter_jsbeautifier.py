from ..core import Module

INTERPRETERS = ['node']
EXECUTABLES = ['js-beautify']
DOTFILES = ['.jsbeautifyrc']
MODULE_CONFIG = {
    'source': 'https://github.com/beautify-web/js-beautify',
    'name': 'JSBeautifier',
    'uid': 'jsbeautifier',
    'type': 'beautifier',
    'syntaxes': ['js', 'css', 'html', 'json', 'tsx', 'vue'],
    'exclude_syntaxes': {
        'html': ['markdown']
    },
    'executable_path': '/path/to/node_modules/.bin/js-beautify(.cmd on windows)',
    'args': None,
    'config_path': {
        'default': 'jsbeautify_rc.json'
    },
    'comment': 'Omit "interpreter_path" as files in /node_modules/.bin/ already point to node.'
}


class JsbeautifierFormatter(Module):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def get_cmd(self):
        cmd = self.get_combo_cmd(runtime_type='node')
        if not cmd:
            return None

        path = self.get_config_path()
        if path:
            cmd.extend(['--config', path])

        syntax = self.get_assigned_syntax()
        cmd.extend(['--type', syntax if syntax in ('js', 'css', 'html') else 'js'])

        return cmd

    def format(self):
        cmd = self.get_cmd()

        try:
            exitcode, stdout, stderr = self.exec_cmd(cmd)

            if exitcode > 0:
                self.print_exiterr(exitcode, stderr)
            else:
                return stdout
        except Exception as e:
            self.print_oserr(cmd, e)

        return None
