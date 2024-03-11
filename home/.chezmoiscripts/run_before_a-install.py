#!/usr/bin/python3
# TODO: Use dataclass-wizard to avoid all validations
# 
import json
import logging
import os
import sys
import distro
import traceback
import uuid
from dataclasses import dataclass
from typing import cast
import subprocess
import datetime
from dataclass_wizard import asdict, fromdict
import shutil
from getpass import getpass

BASE_DIR = os.path.expanduser("~/.local/share/chezmoi")
VAULT_PATH = os.path.join(BASE_DIR,"vault")
LEVEL = logging.INFO
LOG_DIR = os.path.join(BASE_DIR,".log")
TMP_DIR = os.path.join(os.path.dirname(__file__),".tmp")
LAST_EXEC_FILE = os.path.join(BASE_DIR,".last_exec")
INSTALL_IF_NOT_CHECK_IS_PRESENT = True

LOGGER = logging.getLogger(__name__)
PASSWD = ""

ENV = os.environ

@dataclass
class InstallDSL:
    packages: list[dict]
    wsl:            bool                                = True
    before:         dict[str,list[str] | None] | None   = None
    after:          dict[str,list[str] | None] | None   = None
    vars:           dict[str,str] | None                = None
    fail_fast:      bool                                = True

def diff(niu: InstallDSL, old: InstallDSL|None) -> InstallDSL | None:
    if old is None:
        return niu
    if niu == old:
        return None
    if niu != old or niu.vars != old.vars:
        return niu
    packages = [p for p in niu.packages if p not in old.packages]

    return InstallDSL(packages,niu.wsl,niu.before,niu.after,niu.vars,niu.fail_fast)


def log(smt,level = logging.INFO):
    if type(smt) is str:
        smt = smt.replace(PASSWD,"*" * len(PASSWD))
    elif type(smt) is list:
        smt = [i.replace(PASSWD,"*" * len(PASSWD)) for i in smt]

    LOGGER.log(level,smt)


def inject_sudo(script: list[str]|str) -> list[str] | str:
    if type(script) is str:
        return f"(echo {PASSWD} | sudo -S -v -p '') ; {script}"

    stack = []
    result = [f"echo {PASSWD} | sudo -S -v -p ''"]
    opening = ["[","(","\"","'"]
    closing = ["]",")","\"","'"]
    for line in script:
        is_escaped = line.endswith("\\")
        for char in line:
            if char in opening:
                stack.append(char)
            elif char in closing:
                if closing.index(char) == opening.index(stack[-1]):
                    stack.pop()

        result.append(line)
        if not is_escaped and len(stack) == 0:
            result.append(f"echo {PASSWD} | sudo -S -v -p ''")

    return result


def run(script: str|list[str]) -> int:
    if type(script) is list:
        ext = "sh" if sys.platform != "win32" else "ps1"
        path = os.path.join(TMP_DIR,f"{uuid.uuid4()}.{ext}")
        with open(path,"w") as file:
            script = cast(list,inject_sudo(script))
            log(f"saving script in temp file: {path}",logging.DEBUG)
            log("\n".join(script),logging.DEBUG)
            file.write("\n".join(script))
        exe = ["sh" if sys.platform != "win32" else "powershell.exe" , path]
    else:
        exe = inject_sudo(script)

    log(exe if type(exe) is str else " ".join(exe),logging.DEBUG)
    process = subprocess.Popen(
        exe,
        shell=type(exe) is str,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        bufsize=1,
        universal_newlines=True,
    )

    if process.stdout is not None:
        for line in iter(process.stdout.readline, ''):
            log(f"{line.rstrip('\n')}",logging.INFO)

    return process.wait()


def get_os_keys() -> list[str]:
    keys = ["all"]
    if sys.platform == "win32":
        keys.extends(["win32","windows"])
        return keys

    if sys.platform == "darwin":
        keys.extends(["darwin","macos"])
        return keys

    if sys.platform == "linux":
        keys.append("linux")
        distid = distro.id()
        if distid.lower() in ["ubuntu", "pop_os"]:
            keys.append("ubuntu")
        elif distid.lower() == "fedora":
            keys.append("fedora")
        else:
            raise NotImplemented()
        return keys
    raise NotImplemented()


def get_install_methods() -> list[tuple[str,str,str]]:
    methods: list[tuple[str,str,str]] = [("sh","","")]

    if sys.platform != "win32":
        methods.append(("asdf","asdf plugin list | grep {pkg}",""))

    if sys.platform == "win32":
        methods.extends([
            (
                "winget",
                "winget install --id {pkg} --accept-source-agreements --accept-package-agreements --silent",
                "powershell -c \" winget list --id {pkg} *>$null ; exit $LASTEXITCODE \""
            ),
            (
                "scoop",
                "scoop install {pkg}",
                "powershell -c  \"if ($(scoop.ps1 list {pkg} 6> $null) -eq $null) { exit 1 }) ; exit $LASTEXITCODE \""
            )])
        return keys

    if sys.platform == "linux":
        distid = distro.id()
        if distid.lower() in ["ubuntu", "pop_os"]:
            methods.append(("apt","sudo apt install -y {pkg}","dkpg -l | grep 'ii  {pkg}'"))
        elif distid.lower() == "fedora":
            methods.append(("dnf","sudo dnf install -y {pkg}","dnf list installed {pkg}"))
        else:
            raise NotImplemented()
        return methods

    raise NotImplemented()


def process(data: InstallDSL):
    global PASSWD

    if PASSWD == "" and sys.platform != "win32":
        ec = -1
        while ec != 0:
            PASSWD = getpass("sudo password: ")
            log("checking password...")
            ec = run(f"echo {PASSWD} | sudo -S -v -p ''")


    log("setting up environment variables")
    if sys.platform == "linux":
        ENV["PATH"] = "/home/david/.local/share/pnpm:/home/david/.local/bin:/opt/asdf/shims:/opt/asdf/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

    if data.vars is not None:
        for key,value in data.vars.items():
            ENV[key] = value

    log(ENV,logging.DEBUG)

    log("processing global before script")
    if data.before is not None:
        for key in get_os_keys():
            if key not in data.before:
                continue
            before = cast(list,data.before[key])
            ec = run(before)
            if ec != 0:
                if data.fail_fast:
                    raise Exception("failed execution of install section and configured to fail fast. exiting")

                log(f"failed execution of before script (global). skipping file",logging.ERROR)
                log("cleaning environment variables")
                if data.vars is not None:
                    for key,value in data.vars.items():
                        ENV[key] = ""
                return

    log("processing packages")
    for package in data.packages:
        for key in get_os_keys():
            if key not in package:
                continue

            info = package[key]
            for method,_install,_check in get_install_methods():
                if method not in info:
                    continue

                log(f"package {package['name']} on {key} via {method}")

                install: list[str] | str
                check: str | bool
                inbefore: str | None = None
                inafter: str | None = None

                if method == "sh":
                    installation: list[str]|str|dict = info[method]
                    if type(installation) is list:
                        install = installation
                        check = INSTALL_IF_NOT_CHECK_IS_PRESENT
                    elif type(installation) is dict:
                        assert "script" in installation, Exception("'script' must be in 'sh'")
                        assert type(installation["script"]) is list, Exception("'sh.script' must be an array")
                        install = installation["script"]
                        check = installation.get("check",INSTALL_IF_NOT_CHECK_IS_PRESENT)
                        inbefore = installation.get("before",None)
                        inafter = installation.get("after",None)
                    else:
                        raise Exception("'sh' must be array or object")
                elif method == "asdf":
                    installation = info[method]
                    assert type(installation) is dict, Exception("'asdf' must be an object")
                    assert "use" in installation and "plugin" in installation, Exception("'use' and 'plugin' must be in 'asdf'")
                    assert type(installation["use"]) is str and type(installation["plugin"]) is str, Exception("'use' and 'plugin' must be string")
                    check = "[ -f /opt/asdf/asdf.sh ] && . /opt/asdf/asdf.sh && " + installation.get("check",_check.format(pkg=installation["plugin"].split(" ")[0]))
                    install = [
                        "[ -f /opt/asdf/asdf.sh ] && . /opt/asdf/asdf.sh",
                        f"asdf plugin add {installation['plugin']}",
                        "" if "install" not in installation else f"asdf install {installation['install']}",
                        f"asdf use global {installation['use']}"
                    ]
                    inbefore = installation.get("before",None)
                    inafter = installation.get("after",None)
                else:
                    installation = info[method]
                    if type(installation) is dict:
                        assert "pkg" in installation, Exception(f"'pkg' must be in {method}")
                        install = _install.format(pkg=installation["pkg"])
                        check = installation.get("check",_check.format(pkg=installation["pkg"]))
                        inbefore = installation.get("before",None)
                        inafter = installation.get("after",None)
                    elif type(installation) is str:
                        install = _install.format(pkg=installation)
                        check = _check.format(pkg=installation)
                    else:
                        raise Exception(f"{method} must be an object or string")

                if inbefore is not None:
                    log("processing local before script")
                    ec = run(inbefore)
                    if ec != 0:
                        if data.fail_fast:
                            raise Exception("failed execution of before script and configured to fail fast. exiting")
                        log("failed execution of before script. skipping the package",logging.ERROR)
                        continue

                log(f"checking if {package['name']} is installed")
                should_install = bool(check)
                if type(check) is str:
                    ec = run(check)
                    should_install = ec != 0
                    if ec != 0:
                        log(f"{package['name']} is not installed")

                if should_install:
                    log(f"installing {package['name']} via {method}")
                    ec = run(install)
                    if ec != 0:
                        if data.fail_fast:
                            raise Exception("failed execution of install section and configured to fail fast. exiting")
                        log(f"failed execution of install script. check configs of {package['name']}",logging.ERROR)


                if inafter is not None:
                    log("processing local after script")
                    ec = run(inafter)
                    if ec != 0:
                        if data.fail_fast:
                            raise Exception("failed execution of after script and configured to fail fast. exiting")
                        log("failed execution of after script. some things will have to be made manually...",logging.ERROR)

                log("")

    log("processing global after script")
    if data.after is not None:
        for key in get_os_keys():
            if key not in data.after:
                continue
            after = cast(list,data.after[key])
            ec = run(after)
            if ec != 0:
                if data.fail_fast:
                    raise Exception("failed execution of install section and configured to fail fast. exiting")
                log(f"failed execution of after script (global). some things will have to be made manually...",logging.ERROR)
                return

    log("cleaning environment variables")
    if data.vars is not None:
        for key,value in data.vars.items():
            ENV[key] = ""

if not os.path.exists(LOG_DIR):
    os.mkdir(LOG_DIR)



file_handler = logging.FileHandler(os.path.join(LOG_DIR,f"{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.log"))
console_handler = logging.StreamHandler()
formatter = logging.Formatter("%(asctime)s %(levelname)s: %(message)s")
file_handler.setFormatter(formatter)
console_handler.setFormatter(formatter)
LOGGER.addHandler(file_handler)
LOGGER.addHandler(console_handler)
logging.basicConfig(level=LEVEL)

try:
    if not os.path.exists(TMP_DIR):
        log(f"creating tmp dir {TMP_DIR}",logging.DEBUG)
        os.mkdir(TMP_DIR)

    log("getting last_exec database",logging.DEBUG)
    if not os.path.exists(LAST_EXEC_FILE):
        last_exec = {}
    else:
        with open(LAST_EXEC_FILE) as file:
            last_exec = json.load(file)

    for filename in os.listdir(VAULT_PATH):
        path = os.path.join(VAULT_PATH,filename)
        if not os.path.isfile(path):
            continue

        with open(path, "r") as file:
            try:
                _data = fromdict(InstallDSL,json.load(file))
                prev = None if path not in last_exec else fromdict(InstallDSL,last_exec[path])
                data = diff(_data,prev)
                if data is not None:
                    process(data)
                last_exec[path] = asdict(_data)
            except json.JSONDecodeError:
                raise Exception(f"file {path} not valid JSON")

    with open(LAST_EXEC_FILE,"w") as file:
        json.dump(last_exec,file)

except Exception as e:
    LOGGER.error(e)
    LOGGER.error(traceback.format_exc())
finally:
    log("removing tmp dir",logging.DEBUG)
    shutil.rmtree(TMP_DIR)
