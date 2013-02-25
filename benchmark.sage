load("Subwords_node.sage")

def normal():
    k = [perm.avoids(u) for u in patts]

def functional():
    k = [perm.avoids(u) for u in patts]

def benchmark_reg_perm(n):
    return Permutations(n).random_element()

def benchmark_functional_perm(n):
    return Perm(list(Permutations(n).random_element()))

def benchmark_list(n, l):
    q = [Permutations(n).random_element() for i in range(l)]
    q = map(list, q)
    # q = Permutations(n).random_element()
    return q
def feeh(n):
    bleh = []
    for i in range(n):
        bleh.append(n)

tests = 5
patt_len = 5
perm_len = 10
regular = Permutations(perm_len).random_element()
func = Perm(list(regular))
q = benchmark_list(tests, patt_len)


# if __name__ == '__main__':
    # import timeit
    # print "Hello benchmark"
    # print functional, type(functional)
    # print test_patterns, type(test_patterns)
    # print "Patterns: %s" % test_patterns
    # print "Permutation: %s" % regular
    # print "Running test for regular Permutation"
    # t = timeit.Timer("normal(regular, test_patterns)", setup="from __main__ import normal")
    # # print t
    # print "Running test for functional Permutation"
    # t = timeit.Timer("functional(functional, test_patterns)", setup="from __main__ import functional")
    # # print t


    # regular()
    # normal(regular, test_patterns)
    # timeit.Timer("feeh(100)", setup="from __main__ import feeh")
    # print "Finished"



