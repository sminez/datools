# Truncate the path for display
function tpath {
        ([[ $(pwd) == $HOME ]] || [[ $(pwd) < $HOME ]]) && echo $(pwd) || ([[ $(pwd) > $HOME ]] &&echo $(pwd | awk -F'/' '{ print "../" $(NF-1)"/" }'))
}
 # Show final element if under $HOME
function tpath2 {
        [[ $(pwd) > $HOME ]] && echo '%1~'
}

function in_git_repo {
        if git ls-files >& /dev/null; then
                echo "in git"
        fi
}

function git_branch_name {
        [[ $(in_git_repo) == 'in git' ]] && echo  "≺  $(git symbolic-ref --short HEAD 2> /dev/null)≻"
}

function git_dirty {
        ([[ $(git diff --shortstat 2> /dev/null | tail -1) != "" ]] && echo '✘') || echo '✔'
}

# Build the prompts
PROMPT='%{$FG[003]%}%n%{$FG[238]%}@%{$FG[003]%}%m %{$FG[238]%}ζ %{$FG[250]%}$(git_branch_name) %{$FG[240]%}$(tpath)%{$FG[003]%}$(tpath2)
%{$FG[202]%}λ く'
RPROMPT='%{$FG[023]%}⚓%{$FG[240]%}|%{$FG[003]%}$(git_dirty) %{$FG[240]%}|%(?.%{$FG[240]%}%?.%{$FG[202]%}%?)%{$FG[240]%}|%{$FG[004]%}%T'
