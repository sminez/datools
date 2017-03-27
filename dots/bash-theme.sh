#!/usr/bin/env bash

# This is a modified vertion of the powerline theme provided
# by the BASH_IT framework and the bash-powerline theme.

SEPARATOR=""
VENV_CHAR="⚕ "
GIT_AHEAD="⇡"
GIT_BEHIND="⇣"

# Specific color vars
COLOR=38
VENV_COLOR=30
GIT_COLOR=238
GIT_CLEAN_COLOR=231
GIT_DIRTY_COLOR=167
CWD_COLOR=240
LAST_STATUS_COLOR=1
normal="\[\e[0m\]"
bold_white="\[\e[37;1m\]"


function set_rgb_color {
    # Helper to avoid having to type ansi colour excapes!
    if [[ "${1}" != "-" ]]; then
        
        fg="38;5;${1}"
    fi
    if [[ "${2}" != "-" ]]; then
        bg="48;5;${2}"
        [[ -n "${fg}" ]] && bg=";${bg}"
    fi
    echo -e "\[\033[${fg}${bg}m\]"
}

function powerline_shell_prompt {
    # Main prompt components
    PROMPT_COLOR=${COLOR}
    if sudo -n uptime 2>&1 | grep -q "load"; then
        PROMPT_COLOR=${COLOR_SUDO}
    fi
    # PROMPT="\u@\h"
    PROMPT="\A ζ"
    PROMPT="${bold_white}$(set_rgb_color - ${PROMPT_COLOR}) ${PROMPT} ${normal}"
    LAST_THEME_COLOR=${PROMPT_COLOR}
}

function powerline_virtualenv_prompt {
    # Display the current venv if we are in one
    local environ=""

    if [[ -n "$VIRTUAL_ENV" ]]; then
        # basename is a builtin that strips leading dir components
        # and optionally the file extension as well (man basename)
        environ=$(basename "$VIRTUAL_ENV")
    fi

    if [[ -n "$environ" ]]; then
        VENV_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${VENV_COLOR})${SEPARATOR}${normal}$(set_rgb_color - ${VENV_COLOR}) ${VENV_CHAR}$environ ${normal}"
        LAST_THEME_COLOR=${VENV_COLOR}
    else
        VENV_PROMPT=""
    fi
}

function powerline_git_prompt {
    # Only run if ina  git repo
    if git ls-files >& /dev/null; then
        # Get the current branch name or short SHA1 hash for detached head
        local BRANCH="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"

        # Set the background colour of the segment based on branch status
        if [[ -n "$(git status --porcelain)" ]]; then
            GIT_PROMPT="$(set_rgb_color ${GIT_DIRTY_COLOR} ${GIT_COLOR})  $BRANCH"
        else
            GIT_PROMPT="$(set_rgb_color ${GIT_CLEAN_COLOR} ${GIT_COLOR})  $BRANCH"
        fi

        # Find out how many commits the local branch is ahead/behind of the remote
        local STAT="$(git status --branch --porcelain)"
        local UNTRACKED="$(git status --porcelain | grep -e '^??' | wc -l)"
        local MODIFIED="$(git status --porcelain | grep -e '^ M' | wc -l)"
        local N_AHEAD="$(echo $STAT | grep -o -e 'ahead [0-9]\+' | grep -o '[0-9]\+')"
        local N_BEHIND="$(echo $STAT | grep -o 'behind [0-9]\+' | grep -o '[0-9]\+')"
        # Add the info into the prompt
        [ "$UNTRACKED" -gt 0 ] && GIT_PROMPT+=" ?$UNTRACKED"
        [ "$MODIFIED" -gt 0 ] && GIT_PROMPT+=" ~$MODIFIED"
        [ -n "$N_AHEAD" ] && GIT_PROMPT+=" $GIT_AHEAD$N_AHEAD"
        [ -n "$N_BEHIND" ] && GIT_PROMPT+=" $GIT_BEHIND$N_BEHIND"
        GIT_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${GIT_COLOR})${SEPARATOR}${normal}${GIT_PROMPT} ${normal}"
        LAST_THEME_COLOR=${GIT_COLOR}
    else
        GIT_PROMPT=""
    fi
}

function powerline_cwd_prompt {
    # Display the current working directory
    CWD_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${CWD_COLOR})${SEPARATOR}${normal}$(set_rgb_color - ${CWD_COLOR}) \w ${normal}$(set_rgb_color ${CWD_COLOR} -)${normal}"
    LAST_THEME_COLOR=${CWD_COLOR}
}

function powerline_last_status_prompt {
    if [[ "$1" -eq 0 ]]; then
        LAST_STATUS_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} -)${SEPARATOR}${normal}"
    else
        LAST_STATUS_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${LAST_STATUS_COLOR})${SEPARATOR}${normal}$(set_rgb_color - ${LAST_STATUS_COLOR}) ${LAST_STATUS} ${normal}$(set_rgb_color ${LAST_STATUS_COLOR} -)${SEPARATOR}${normal}"
    fi
}

function powerline_prompt_line {
    # Display a prompt line below the main information
    
    # PROMPT_LINE="${bold_white}$(set_rgb_color - ${PROMPT_COLOR}) ~ ${normal}$(set_rgb_color ${PROMPT_COLOR} -)${SEPARATOR}${normal} "
    # PROMPT_LINE="${bold_white} $ ${normal}"
    # PROMPT_LINE="≻  "
    PROMPT_LINE="\$ ~ "
}

function build_prompt() {
    # Combine all of the segments and provide a function to update the prompt
    powerline_shell_prompt
    powerline_virtualenv_prompt
    powerline_git_prompt
    powerline_cwd_prompt
    powerline_last_status_prompt LAST_STATUS
    powerline_prompt_line

    PS1="${PROMPT}${VENV_PROMPT}${GIT_PROMPT}${CWD_PROMPT}${LAST_STATUS_PROMPT}\n${PROMPT_LINE}"
}

PROMPT_COMMAND=build_prompt
