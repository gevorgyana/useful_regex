# filter stuff - designed to be used with find
alias n=$' awk -F "/" \' {print $2 } \' | sort | uniq -c'

# The following things are meant to work recursively (-r flag)
# always ignore binary files (-I), need only the filenames (-l)

# perl regex can do more than plain regex, for example,
# we can use the following regex expressions
# in a context where the regex tool will see the file as a
# string (regardless of the lines; it will one single line
# that ends with EOF symbol).
#
# this should work
# [  r="int[ \n]*main"  ]
# or this too (?s)int.*main (perl regex)
alias pg=$'grep -Plozr "$r" .'
alias pgi=$'grep -Plozri "$r" .'

# general grep
alias gg=$'grep -Ilr "$r" .'
alias ggi=$'grep -Ilri "$r" .'

# x for extended, e is taken by some other program
alias gx=$'grep -EIlr "$r" .'
alias gxi=$'grep -EIlri "$r" .'

## the following are driver commands, probably
## you want to use them in first place

# control regex expression
alias e='echo $r'
chre ()
{
    r="$1"
}

# change regex backend
chreb()
{
   regb="$1"
}

# grep-find 
alias gref=' $regb | n '

# grep-find-less 
alias grefl=' $regb | xargs less '

# grep-find-less-local 
#   (relies on the fact that most filenames that contain
#   source code are files with non-empty extension)
alias grefll=$' gref | awk \' {print $2} \' | grep \'.*\..*\' | xargs less '
