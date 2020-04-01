```grep -Pozl "(?s)The message can't be displayed on one line.*Please see this part of the message on the next line"```

This is a Perl-style regex that searches for different parts of expression that are scattered among several lines; 
it then prints the files where it finds these occurences; it does not print the lines as it would be line #1 in all
cases due to the fact that we turn newlines into null characters here. It it though needed to manually place .* between 
what you think may be delimited by newline or some auxillary text in the original file.

P - perl regex; (?s) - enables .* to match anything - literally anything;
o - output matching piece of line only (otherwise you will see the whole file as output);
z - make grep think that the input is just one single big line (not perl-specific, it can be used with 
usual or extended regex too);
l - print the file names where a match is found;
