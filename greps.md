```grep -Pozlr "(?s)Measurement can.t be completed.*Please" --include="*.cpp" .```

This is a Perl-style regex that searches for different parts of expression that are scattered among several lines; 
it then prints the files where it finds these occurences; it does not print the lines as it would be line #1 in all
cases due to the fact that we turn newlines into null characters here
