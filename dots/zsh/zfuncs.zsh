####################################################################
#! {-- Functions --} # >> Functions used in the prompt are in .zshrc
#####################
#! {show-colors} Show all 256 colors as code:block pairs
show-colors() {
    for code ({000..255}) { print -nP -- "$code: %F{$code}%K{$code}Test%k%f " ; (( code % 8 && code < 255 )) || printf '\n'}
    }
