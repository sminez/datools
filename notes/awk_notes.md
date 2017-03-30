AWK :: text processing FTW
--------------------------

# The implicit AWK loop
Brian Kernighan has stated that adesign goal of awk was to remove as much boiler
plate code as possible and make things that feel like one liners really one
line. With that in mind, all awk scripts are essentially pattern/action pairs:

    pattern_1 { action_1 }
    pattern_2 { action_2 }

With the patterns being applied as follows:

    for each file in the input:
        for each line in the file:
            for each pattern in the program:
                if the pattern matches the line:
                    perform the action

-------------------------------------------------------------------------------

# AWK scripts as programs
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

# BEGIN and END
BEGIN and END are special patterns that are run before processing any input and
after processing _all_ input. They are useful for setting up variables and
computing summaries etc.

-------------------------------------------------------------------------------

# Special Awk variables
FS : Field separator
- Sets which character awk will use for splitting lines into fields(/columns).
  This can also be set using the `-F` flag. It can actually take a regular
  expression, allowing you to use multiple separators:
```
    { FS = "\t" }       # Fields deliminated by tabs
    { FS = "-|,|." }    # Fields deliminated by - , and .
```
OFS : Ouput Field Separator
- Sets the character used by the print statement to deliminate output fields. By
  default this is a single space:
```
    { OFS = " --> " }
```
RS : Record Separator
- By default, awk operates on lines in files as RS is set to '\n'. Changing this
  allows you to process data in other formats. (You will probably need to change
  FS as well!)
```
    { RS = "\n\n"; FS = "\n" }
```
ORS : Output Record Separator
- Same relation to RS as OFS to FS.
```
    { ORS = "\n\n" }
```
NR : Number of Records
- Essentially the loop variable for the implicit master loop described above.
  With default settings this can be though of as the current line number being
  processed. In an END block, NR will have the value of the total number of
  records processed. (Changing RS will obviously change this behaviour as well!)
```
    awk '{ print "This is line ",NR } END { print "There were ",NR," records" }'
```
NF : Number of Fields
- This gives you the total number of Fields in the current record. The following
  example would print out the number of Fields per line in the input file:
```
    awk '{ print NR," --> ",NF }' input_file
```
FILENAME : The Current File Name...
- Useful for when you are processing multiple files at once or if you want to
  include the file name in the script output. The following - super useful -
  script will print the file name once for each line in the file.
```
    awk '{print FILENAME}' input_file
```
FNR : File Number of Records
- Same idea as the NR variable but this one resets at the start of each file.
```
    awk '{ print "This is line ",FNR," for the file and ",NR," in total" }'
```
