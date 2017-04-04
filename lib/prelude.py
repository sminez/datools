'''
A functional Programming prelude of utility functions
-----------------------------------------------------
Std Lib Functional stuff:
https://docs.python.org/3.4/library/itertools.html
https://docs.python.org/3.4/library/functools.html
https://docs.python.org/3.4/library/operator.html

Some info on what haskell does:
https://wiki.haskell.org/Fold
http://learnyouahaskell.com/higher-order-functions

Clojure's core reference:
https://clojuredocs.org/clojure.core
https://clojuredocs.org/quickref
'''
import functools
import itertools
import operator as op
from types import GeneratorType


def reverse(itr):
    '''
    Reverse an iterable
    '''
    return itr[::-1]

# gen_reverse = lambda x: reversed(x)


def prod(cont):
    '''
    Find the product of an iterable. Contents of the iterable must
    implement __mul__
    '''
    return functools.reduce(op.mul, cont)


def foldl(func, acc, cont):
    '''
    Fold a list with a given binary function from the left
    '''
    for val in cont:
        acc = func(acc, val)
    return acc


def foldr(func, acc, cont):
    '''
    Fold a list with a given binary function from the right

    WARNING: Right folds and scans will blow up for
             infinite generators!
    '''
    if isinstance(cont, GeneratorType):
        # Convert to iterator to pass to reduce
        cont = [c for c in cont]

    for val in cont[::-1]:
        acc = func(val, acc)
    return acc


def scanl(func, acc, cont):
    '''
    Use a given accumulator value to build a list of values obtained
    by repeatedly applying acc = func(acc, next(list)) from the left.
    '''
    lst = [acc]
    for val in cont:
        acc = func(acc, val)
        lst.append(acc)
    return lst


def scanr(func, acc, cont):
    '''
    Use a given accumulator value to build a list of values obtained
    by repeatedly applying acc = func(next(list), acc) from the right.

    WARNING: Right folds and scans will blow up for
             infinite generators!
    '''
    if isinstance(cont, GeneratorType):
        # Convert to iterator to pass to reduce
        cont = [c for c in cont]

    # yield acc
    # for val in cont:
    #     acc = func(val, acc)
    #     yield acc
    lst = [acc]
    for val in cont[::-1]:
        acc = func(val, acc)
        lst.append(acc)
    return lst


def take(num, cont):
    '''
    Return up to the first `num` elements of an iterable or generator.
    '''
    try:
        return cont[:num]
    except TypeError:
        # Taking from a generator
        num_items = []
        try:
            for n in range(num):
                num_items.append(next(cont))
            return num_items
        except StopIteration:
            return num_items


def drop(num, cont):
    '''
    Return everything but the first `num` elements of itr
    '''
    try:
        items = cont[num:]
    except TypeError:
        items = []
        for n in range(num):
            # Fetch and drop the initial elements
            try:
                items.append(next(cont))
            except StopIteration:
                break
    return items


def takeWhile(predicate, container):
    '''
    The predicate needs to take a single argument and return a bool.
    (takeWhile ~(< 3) '(1 2 3 4 5)) -> '(1 2)
    '''
    return itertools.takewhile(predicate, container)


def dropWhile(predicate, container):
    '''
    The predicate needs to take a single argument and return a bool.
    (dropWhile ~(< 3) '(1 2 3 4 5)) -> '(3 4 5)
    '''
    return itertools.dropwhile(predicate, container)


def flatten(lst):
    '''
    Flatten an arbitrarily nested list of lists down to a single list
    '''
    _list = ([x] if not isinstance(x, list) else flatten(x) for x in lst)
    return sum(_list, [])


def windowed(size, col):
    '''
    Yield a sliding series of iterables of length _size_ from a collection.

    NOTE:
    - If the collection is a generator it will be drained by this
    - yields [] if the supplied collection has less than _size_ elements
    - keeps _size_ elements in memory at all times
    '''
    remaining = iter(col)
    current_slice = list(take(size, remaining))

    if len(current_slice) < size:
        raise StopIteration
    else:
        while True:
            yield (elem for elem in current_slice)
            next_element = next(remaining)
            if next_element:
                # Slide the window
                current_slice = current_slice[1:] + [next_element]
            else:
                # We've reached the end so return
                break


def l_windowed(size, col):
    '''
    A version of windowed that yields lists rather than generators
    '''
    for w in windowed(size, col):
        yield [elem for elem in w]
