pyk :: AWK-ward Python one liners
---------------------------------

### What is pyk?
`pyk` is my attempt to get the utility of awk one liners with the power and
ecosystem of python. It is _not_ a python based implementation of awk and it is
_definately_ not intended as a full programming language or in fact for scripts
that are more than a few lines long.

What `pyk` _is_ intended for is quick python based processing of text files and
pipeline streams. If you can do it with a tool like awk or grep, do it with awk
or grep.

Seriously. The standard gnu/unix toolkit is well tested, optimised and available
on every unix based system. You can't beat it!

All `pyk` scripts are executed using the following main loop:
```
    for each file in the input:
        for each line in the file:
            for each pattern in the program:
                if the pattern matches the line:
                    perform the action
```
If that's not what you need, write it in pure python!

### So what is the point of pyk?...
The sole selling point of `pyk` is that it is nothing more than a wrapper to run
the awk main loop in python. Patterns and actions are wrapped in awk-like syntax
but the patterns and actions themselves are pure python. Other than generating
the awk context variables (NR, NF etc...) and replacing awk style `$n` field
references with an index into the FIELDS variable, `pyk` passes the line and
fields after splitting straight through to your code.

Oh, and it will auto-resolve imports for you. That's kind of nice too.

### I'm sold! Lets see it in action!
All of the following examples are valid `pyk` scripts:
```bash
# Print every second line of a file
$ pyk 'NR % 2 == 0' file
# Print lines beinging with "foo" along with a message
$ pyk '/^foo/ { print ("I start with foo: ", $0) }' file
# Find the total of the 3rd column of the file
$ pyk 'BEGIN { total = 0 };; { total += $3 };; END { print(total) }' file
# If the value of the second column is a float, print its Sin value
$ pyk 'float($2) == $2 { math.sin($2) }' file
# Enumerate the fields of the first record, one per line
$ pyk 'NR==1 {for i in range(NF): print("    ",i,$i) }' file
```

pyk will implicitly print results of calculations that return anything other
than `None`.
