"""Xonsh Developer Toolkit RC file."""

# $XONSH_SHOW_TRACEBACK=1
# $XONSH_TRACE_SUBPROC=2
# $RAISE_SUBPROC_ERROR=1

_cwd = pf'{__file__}'.parent
source @(_cwd)/callias.xsh


aliases |= {
    # Run xonsh without environment for experimenting.
    'xonsh-no-env': 'xonsh --no-rc --no-env -DPATH -DTERM -DHOME -DXONSH_SHOW_TRACEBACK=1',
}


@aliases.register
def _docker_xonsh_branch(args):
    """Run docker container with xonsh from branch.
    Usage: 
      1. Copy branch url from PR.
      2. `docker-xonsh-branch https://github.com/costajohnt/xonsh/tree/feat/completion-underline-highlight`
    """
    url = args[0]
    m = @.imp.re.match(r"https://github.com/([^/]+)/([^/]+)/tree/(.+)", url)
    if not m:
        print("Invalid GitHub tree URL")
        return

    owner, repo, branch = m.groups()
    git_url = f"https://github.com/{owner}/{repo}.git"

    host = owner + '_' + repo + '_' + branch

    docker run --rm -it -h @(host) xonsh/xonsh bash -lc @(f"""
        set -e
        git clone --depth 1 --single-branch --branch {branch} {git_url} /tmp/xonsh
        pip install -e '/tmp/xonsh[full]'
        exec bash
        """)
