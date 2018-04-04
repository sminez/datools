#! /usr/bin/python3.6
'''
A simple tool for checking whether it is worthwhile converting
csv data to numpy sparse arrays for storage.

Input can be a single csv, a zip archive of csvs or a directory
of csvs.
'''
from functools import reduce
import argparse
import zipfile
import csv
import os
import io


def check_all(dir_or_zip, counts=False):
    '''
    If the argument is a directory then recursively walk it. If it is a zip
    archive then open it and read from the file listing.
    '''
    results = []

    if os.path.isdir(dir_or_zip):
        # Walk the directory and check each csv
        for path, _, files in os.walk(dir_or_zip):
            for fname in files:
                if fname.endswith('csv'):
                    fpath = os.path.join(path, fname)
                    with open(fpath, 'r') as f:
                        data = csv.reader(f)
                        results.append(check_file(data, counts))
    else:
        # This should be a zip archive
        archive = zipfile.ZipFile(dir_or_zip)
        for fname in archive.namelist():
            if fname.endswith('csv'):
                with archive.open(fname) as f:
                    data = csv.reader(io.TextIOWrapper(f))
                    results.append(check_file(data, counts))

    return results


def check_file(csv_data, counts=False, dp=5):
    '''
    If counts=False, return percentage sparcity as a float 0-1.
    If counts=True, return the count of zeros and total values.
    '''
    zeros = 0
    total = 0
    for line in csv_data:
        for val in line:
            if val in [0, 0.0, '0']:
                zeros += 1
            total += 1

    if counts:
        return zeros, total
    else:
        return round(zeros / total, dp)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-i',
        '--input',
        required=True,
    )
    parser.add_argument(
        '--counts',
        required=False,
        action='store_true',
    )

    args = parser.parse_args()
    if os.path.isfile(args.input) and args.input.endswith('csv'):
        with open(args.input, 'r') as f:
            data = csv.reader(f)
            results = [check_file(data, args.counts)]
    else:
        results = check_all(args.input, args.counts)

    if args.counts:
        def total(acc, tup):
            acc[0] += tup[0]
            acc[1] += tup[1]
            return acc
        zeros, total = reduce(total, results, [0, 0])
        print(f'{zeros} zero values of a total of {total}')
        print(f'{round(zeros/total*100, 5)}% total sparsity.')
    else:
        for percentage in results:
            print(percentage)
