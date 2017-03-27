####################################################################
#! {-- Completion settings --} #
################################
#! Start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'       original true
#! Activate color-completion
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}
#! Format on completion
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}%B%d%b%{\e[0m%}'
#! Complete 'cd -<tab>' with menu
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
#! Insert all expansions for expand completer
zstyle ':completion:*:expand:*'        tag-order all-expansions
zstyle ':completion:*:history-words'   list false
#! Activate menu
zstyle ':completion:*:history-words'   menu yes
#! Ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes
#! Match uppercase from lowercase
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'
#! Separate matches into groups
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''
#! If there are more than 5 options allow selecting from a menu
zstyle ':completion:*'               menu select=3
zstyle ':completion:*:messages'        format '%d'
zstyle ':completion:*:options'         auto-description '%d'
#! Describe options in full
zstyle ':completion:*:options'         description 'yes'
#! On processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'
#! Offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
#! Provide verbose completion information
zstyle ':completion:*'                 verbose true
zstyle ':completion:*:-command-:*:'    verbose false
#! Set format for warnings
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
#! Define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'          prompt 'correct to: %e'
#! Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'
#! Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'
#! Complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select
#! Provide .. as a completion
zstyle ':completion:*' special-dirs ..

#! Run rehash on completion so new installed program are found automatically:
_force_rehash() {
(( CURRENT == 1 )) && rehash
return 1
}

#! Try to be smart about when to use what completer...
setopt correct
zstyle -e ':completion:*' completer '
if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]] ; then
    _last_try="$HISTNO$BUFFER$CURSOR"
    reply=(_complete _match _ignored _prefix _files)
else
    if [[ $words[1] == (rm|mv) ]] ; then
        reply=(_complete _files)
    else
        reply=(_oldlist _expand _force_rehash _complete _ignored _correct _approximate _files)
    fi
fi'

# caching
[[ -d $ZSHDIR/cache ]] && zstyle ':completion:*' use-cache yes && \
                    zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/
