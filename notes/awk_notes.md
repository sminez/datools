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
