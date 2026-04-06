set -g VIRTUALFISH_VERSION 2.5.9
set -g VIRTUALFISH_PYTHON_EXEC /home/neo/.local/share/pipx/venvs/virtualfish/bin/python
set -l vf_path (find /home/neo/.local/share/pipx/venvs/virtualfish/lib -name "virtual.fish" -path "*/virtualfish/*" 2>/dev/null | head -1)
and source $vf_path
and emit virtualfish_did_setup_plugins