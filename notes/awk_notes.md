AWK :: text processing FTW
--------------------------

### The implicit AWK loop
Brian Kernighan has stated that a design goal of awk was to remove as much
boiler plate code as possible and make things that feel like one liners really
one line.

With that in mind, all awk scripts are essentially pattern/action pairs:
```
    pattern_1 { action_1 }
    pattern_2 { action_2 }
```
With the patterns being applied as follows:
```
    for each file in the input:
        for each line in the file:
            for each pattern in the program:
                if the pattern matches the line:
                    perform the action
```
Each line in an awk program _must_ contain at least a pattern or an action
(usually both) and if you line wrap you need to use a \ to continue the line.
The parser will _not_ associate the pattern with the action without this!
```
    pattern \
        { action }      # This is fine

    pattern
        { action }      # This is not
```
If a line only has a pattern, the default action is to print the line.

If a line only has an action, the default pattern matches every line of input.

-------------------------------------------------------------------------------

### AWK scripts as programs
While the quick and easy way to use awk is as a command like grep or sed:

```bash
$ cat my-data | awk -F, '{ print $1,$2 }'
```

Awk scripts can be made executable with the following shebang line:

```bash
#! /usr/bin/awk -f
```

The -f flag is required to tell awk that the file is to be treated as an input
script rather than a data file to be processed. As the result is a running awk
process, the standard awk command line flags can be used: `-F,` to set the
deliminator as commas for example.

-------------------------------------------------------------------------------

### BEGIN and END
BEGIN and END are special patterns that are run before processing any input and
after processing _all_ input. They are useful for setting up variables and
computing summaries etc:
```
    BEGIN { print "Summing column 2 for lines starting with '1'" }
    '/^1/ { sum += $2 }
    END { print sum }'
```
Note that they really are patterns in the same sense as other awk patterns: they
_match_ the start of input and the end of input.

-------------------------------------------------------------------------------

### Special Awk variables
#### FS : Field separator
- Sets which character awk will use for splitting lines into fields(/columns).
  This can also be set using the `-F` flag. It can actually take a regular
  expression, allowing you to use multiple separators:
```
    { FS = "\t" }       # Fields deliminated by tabs
    { FS = "-|,|." }    # Fields deliminated by - , and .
```
#### OFS : Ouput Field Separator
- Sets the character used by the print statement to deliminate output fields. By
  default this is a single space:
```
    { OFS = " --> " }
```
#### RS : Record Separator
- By default, awk operates on lines in files as RS is set to '\n'. Changing this
  allows you to process data in other formats. (You will probably need to change
  FS as well!)
```
    { RS = "\n\n"; FS = "\n" }
```
#### ORS : Output Record Separator
- Same relation to RS as OFS to FS.
```
    { ORS = "\n\n" }
```
#### NR : Number of Records
- Essentially the loop variable for the implicit master loop described above.
  With default settings this can be though of as the current line number being
  processed. In an END block, NR will have the value of the total number of
  records processed. (Changing RS will obviously change this behaviour as well!)
```
    awk '{ print "This is line ",NR } END { print "There were ",NR," records" }'
```
#### NF : Number of Fields
- This gives you the total number of Fields in the current record. The following
  example would print out the number of Fields per line in the input file:
```
    awk '{ print NR," --> ",NF }' input_file
```
#### FILENAME : The Current File Name...
- Useful for when you are processing multiple files at once or if you want to
  include the file name in the script output. The following - super useful -
  script will print the file name once for each line in the file.
```
    awk '{ print FILENAME }' input_file
```
#### FNR : File Number of Records
- Same idea as the NR variable but this one resets at the start of each file.
```
    awk '{ print "This is line ",FNR," for the file and ",NR," in total" }'
```

-------------------------------------------------------------------------------

### Regular expressions
_NOTE:: Depending on the implementation of awk (Linux ususally comes with
GNU-AWK - aka gawk) you may or may not have access to extended regular
expressions._

Awk regular expression patterns take their syntax from sed:
```
    /REGEX/ { action }
```
With the standard wildcards and special characters you would expect. Note that
`^` and `$` match the start and end of _records_ depending on how you have
defined records via the RS variable. (By default, RS = '\n' so `^` and `$` match
begining and end of line as you would expect.)

You can also use the `~` and `!~` opertors to regex against fields:
```
    $1 ~ /^only this$/ { print "found a match!" }
```

-------------------------------------------------------------------------------

### Includes
Awk has an include mechanism for pulling in functions and patterns from other
file:
```
    @include "filepath"    # This can be absolute or relative
```
There _is_ a magic ENVAR of `AWKPATH` that is searched for matching filenames if
you want to set that and load in a way similar to pip installed Python modules
but that relies on the user having the paramater set correctly.

If the included file contains patterns then they will be run as if they were at
that position in the program. If it contains functions then they will now be in
scope.

-------------------------------------------------------------------------------

### Piping inside an action
Awk actions can pipe their output as if they were in the shell:
```
    /^1/ { print $2 | "nl" }
```
This program will collect all lines that start with a `1` and pipe them through
the `nl` program to give you a numbered list of occurrances.

_NOTE:: the shell command that you are piping to must be enclosed in double
quotes!_

There is a subtle gotcha with this however:
```
    /^1/ { print "started with 1" | "nl" }
    /^2/ { print "started with 2" }
```
In this program, the `"started with 2"` lines will print _before_ the `"started
with 1"` lines as _all_ of the input for the pipe is collected and sent once the
file has been processed.
```
    /^1/ { print "started with 1" | "nl" }
    /^2/ { print "started with 2" | "cat" }
```
This one has the same behavour again.
```
    /^1/ { print "started with 1" | "nl" }
    /^2/ { print "started with 2" | "grep 2" }
```
Whereas _this_ program will print in what would be the expected order...! It
looks like the behaviour is down to the program being piped to: if the target of
the pipe requires full output then it will block and only run at the end of the
awk program. In this case, the output of the blocked programs seem to be displayed
in sequence.
