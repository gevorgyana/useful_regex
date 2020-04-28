## big todo - support caching!!!
## it is very useful
## anyway everyone uses git restore/reset to get
## back to the committed state and indexes meaningful 
## changes (but still it is possible to watch the  state of
## the files in the subdirectories first (if it has not changed,
## fallback to cache)

## another todo; gref may support accepting just classname
## and then trying to find the defintion of it automatically
## like this:
## IN:         ClassName
## PROCESSED:  "class[ \n]*ClassName[\n ]*\{" 
##  // of course there could be comments in between, so better use clang tools for this type of work
##  // solution is either intergrati with clang ( a lot of work ) or just do it like this for now
##  // or think of specifying comments here; but still in theory anything could happen because of the
##  // preprocessor, so ideally I need clang for this
## this may be done on the regex level, just to transform the
## $r before it gets to the grep backend

# filter stuff - designed to be used with find
alias n=$' awk -F "/" \' {print $2 } \' | sort | uniq -c'

# The following things are meant to work recursively (-r flag)
# always ignore binary files (-I), need only the filenames (-l)

# perl regex can do more than plain regex, for example,
# we can use the following regex expressions
# in a context where the regex tool will see the file as a
# string (regardless of the lines; it will one single line
# that ends with EOF symbol).
# this should work
# [  r="int[ \n]*main"  ]
# or this too
# [  (?s)int.*main (perl regex)  ]
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

## using eval is nasty, but what can I do? todo fix this

# grep-find 
alias gref=' eval $regb | n '

# grep-find-less 
alias grefl=' eval $regb | xargs less '

# grep-find-less-local 
#   (relies on the fact that most filenames that contain
#   source code are files with non-empty extension)
alias grefll=$' gref | awk \' {print $2} \' | grep \'.*\..*\' | xargs less '
