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
## PROCESSED:  "class[ \n]*ClassName[\n ]*\{" OR MAYBE THIS "class ClassName[^;]
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

# Using this stack implementation in Bash https://gist.github.com/bmc/1323553

# Todo make these drivers more useful - push should automatically create a stack
# if it is not already there; right now u need to create it manually for every Bash 
# session

# Todo store the state of regex backend too as sometimes it may be important

# Same as the original version
stack_exists ()
{
    : ${1?'Missing stack name'};
    eval '_i=$'"_stack_$1_i";
    if [[ -z "$_i" ]]; then
        return 1;
    else
        return 0;
    fi
}

# Same as the original
no_such_stack ()
{
    : ${1?'Missing stack name'};
    stack_exists $1;
    ret=$?;
    declare -i x;
    let x="1-$ret";
    return $x
}

# Same as the original
stack_destroy
{
    : ${1?'Missing stack name'}
    eval "unset _stack_$1 _stack_$1_i"
    return 0
}


# Same as the original
stack_new ()
{
    : ${1?'Missing stack name'};
    if stack_exists $1; then
        echo "Stack already exists -- $1" 1>&2;
        return 1;
    fi;
    eval "declare -ag _stack_$1";
    eval "declare -ig _stack_$1_i";
    eval "let _stack_$1_i=0";
    return 0
}

stack_pop ()
{
    : ${1?'Missing stack name'};
    : ${2?'Missing name of variable for popped result'};
    eval 'let _i=$'"_stack_$1_i";
    if no_such_stack $1; then
        echo "No such stack -- $1" 1>&2;
        return 1;
    fi;
    if [[ "$_i" -eq 0 ]]; then
        echo "Empty stack -- $1" 1>&2;
        return 1;
    fi;
    let _i-=1;
    eval "$2"='$'"{_stack_$1[$_i]}";
    eval "unset _stack_$1[$_i]";
    eval "_stack_$1_i=$_i";
    unset _i;
    return 0
}


# This version of push differs from the original one in that it saves 'first second'
# as one item in the stack, whereas the original version would see it as two words
# delimited by a space;
stack_push ()
{
    : ${1?'Missing stack name'};
    : ${2?'Missing item to push'};
    if no_such_stack $1; then
        echo "No such stack -- $1" 1>&2;
        return 1;
    fi;
    stack="$1";
    shift 1;
    eval '_i=$'"_stack_${stack}_i";
    eval "_stack_${stack}[$_i]='$@'";
    eval "let _stack_${stack}_i+=1";
    unset _i;
    return 0
}


function gapply ()
{
    stack_pop patterns r
}

function gstash ()
{
    stack_push patterns $1
}
