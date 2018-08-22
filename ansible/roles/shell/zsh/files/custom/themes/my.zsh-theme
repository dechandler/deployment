
local return_status="%(?:%{$fg_bold[green]%}%(!.#.$)%s:%{$fg_bold[red]%}%(!.#.$)%s)"

local root_host_info="%{$fg_bold[red]}%m%{$reset_color}"
local unprivileged_host_info="%{$fg[magenta]%}%n%{$fg[blue]%}@%{$fg[yellow]%}%m%{$reset_color%}"

local host_info="%(!.${root_host_info}.${unprivileged_host_info})"

PROMPT='%{$fg[green]%}%~ %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}% ${return_status}%{$reset_color%} '

RPROMPT="${host_info}"

ZSH_THEME_GIT_PROMPT_PREFIX="(" #%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY_PREFIX="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) "  #%{$fg[yellow]%}✗ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) "
