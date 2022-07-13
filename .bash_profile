# HOMEBREW_ROOT_PATH=${HOMEBREW_ROOT_PATH:-'/opt/homebrew'}
# eval $($HOMEBREW_ROOT_PATH/bin/brew shellenv)

alias gitclean='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias gitdiff="git diff --color | diff-so-fancy"

# HEROKU: Rebuild database from local backup
db:rebuild() {
  local dbname=$(grep "_development" config/database.yml | sed 's/^.*: //') 
  echo "Restoring Database: $dbname"
  dropdb $dbname
  createdb $dbname
  pg_restore --verbose --clean --no-acl --no-owner -h localhost -d $dbname latest.dump
  echo "Done."
}

# HEROKU: Refetch database from heroku and rebuild database
db:refetch() {
  echo "Fetching Backup"
  rm latest.dump
  if [ $# -eq 0 ] 
  then
    heroku pg:backups:download
  else
    heroku pg:backups:download -a $1
  fi

  db:rebuild
}

# Add Postgres commands from Postgres.app
# PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
# Add ./bin to make running Rails commands with Spring the default
# PATH=./bin:$PATH

# Git Completion & Repo State
[[ -r "$HOMEBREW_ROOT_PATH/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_ROOT_PATH/etc/profile.d/bash_completion.sh"

MAGENTA="\[\033[0;35m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[34m\]"
LIGHT_GRAY="\[\033[0;37m\]"
CYAN="\[\033[0;36m\]"
GREEN="\[\033[0;32m\]"
GIT_PS1_SHOWDIRTYSTATE=true
export LS_OPTIONS=\'--color=auto\'
export CLICOLOR=\'Yes\'
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
export PS1=$LIGHT_GRAY"\u@\h"'$(
    if [[ $(__git_ps1) =~ \*\)$ ]]
    # a file has been modified but not added
    then echo "'$YELLOW'"$(__git_ps1 " (%s)")
    elif [[ $(__git_ps1) =~ \+\)$ ]]
    # a file has been added, but not commited
    then echo "'$MAGENTA'"$(__git_ps1 " (%s)")
    # the state is clean, changes are commited
    else echo "'$CYAN'"$(__git_ps1 " (%s)")
    fi)'$BLUE" \w"$GREEN": "



# Language envs
eval "$(nodenv init -)"
# eval "$(rbenv init -)"
