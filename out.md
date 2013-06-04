#### June 4th 2013, avs.spyx

    sage: timeit("count_avoiders_slow([1,3,2,4], 9)", repeat=1, number=1)
    1 loops, best of 1: 54.2 s per loop
    sage: timeit("count_avoiders_fast([1,3,2,4], 9)", repeat=1, number=1)
    1 loops, best of 1: 12.3 s per loop
    sage: 54.2 / 12.3
    4.40650406504065
    sage: timeit("count_avoiders_fast([1,3,2,4], 9)", repeat=1, number=1)
    KeyboardInterrupt
    sage: timeit("count_avoiders_slow([1,3,2,4], 8)", repeat=1, number=1)
    1 loops, best of 1: 4.7 s per loop
    sage: timeit("count_avoiders_fast([1,3,2,4], 8)", repeat=1, number=1)
    1 loops, best of 1: 1.52 s per loop
    sage: timeit("count_avoiders_fast([1,3,2], 9)", repeat=1, number=1)
    1 loops, best of 1: 929 ms per loop
    sage: timeit("count_avoiders_slow([1,3,2], 9)", repeat=1, number=1)
    1 loops, best of 1: 26.7 s per loop
    sage: 26.7 / 0.929
    28.7405812701830
