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
