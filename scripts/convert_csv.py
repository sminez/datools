import argparse
import csv
import os


epilog = '''\
Convert delimited files from one delimiter to another.

By default, this script converts space delimited files to comma
delimited format (CSV) for all '*.csv' files located in the
current directory.

Example use:
>>> # Convert all csv files in the current directory to TSV
>>> python3 convert_csv.py -i"," -o"\t"
>>>
>>> # Convert a single space delimited file to csv
>>> python3 convert_csv.py --file my_data.csv
'''


def convert_file(fname, in_delim, out_delim):
    '''Convert the input file from one delimiter type to the other.'''
    with open('converted/{}'.format(fname), 'w') as out_file:
        writer = csv.writer(out_file, delimiter=out_delim)
        with open(fname, 'r') as in_file:
            for line in csv.reader(in_file, delimiter=in_delim):
                writer.writerow(line)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        epilog=epilog,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        '-i',
        '--input-delimiter',
        default=' ',
    )
    parser.add_argument(
        '-o',
        '--output-delimiter',
        default=',',
    )
    parser.add_argument(
        '-f',
        '--file',
        required=False,
        default=None,
    )

    # Parse the command line arguments
    args = parser.parse_args()

    # Create the output directory
    os.mkdir('converted')

    if args.file is not None:
        convert_file(args.file, args.input_delimiter, args.output_delimiter)
    else:
        for fname in os.listdir():
            if fname.endswith('csv'):
                convert_file(
                    fname, args.input_delimiter, args.output_delimiter
                )
