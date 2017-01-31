local ret_status="%(?:%{$fg_bold[green]%}✔ :%{$fg_bold[red]%}✘ )"
PROMPT='${ret_status} %{$fg_bold[cyan]%}%n %{$reset_color%}in %{$fg_bold[yellow]%}%~%{$reset_color%} $(git_prompt_info)$ '
RPROMPT='%{$fg_bold[cyan]%}[%W | %D{%H:%M:%S.%.}]%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) %{$fg_bold[green]%}"
