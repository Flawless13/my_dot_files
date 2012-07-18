parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1="\n\[\033[31m\]\u@\h \[\033[32m\]\w \[\033[5;36m\]\$(parse_git_branch) \[\033[37m\]\$ "
cd() {
  builtin cd "${@:-$HOME}" && ls -GFA
}

