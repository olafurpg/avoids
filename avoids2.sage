import sys

# @profile
def inverse_on(patt, perm):
    """Applies perm on patt, perm and patt must be of equal length"""
    if len(patt) != len(patt):
        print "trying to inverse permutations of unequal length"
        sys.exit(0)
    inv = [0] * len(perm)
    for i in range(len(perm)):
        # print i, perm, inv
        inv[perm[i] - 1] = patt[i]
    return inv

# @profile
def is_sorted(lst):
    """returns true if lst is sorted, false otherwise"""
    for i in range(1, len(lst)):
        if lst[i] < lst[i - 1]:
            return False
    return True

def is_in(perm, patt):
    # print "Is perm=%s in patt=%s ?" % (perm, patt)
    return is_sorted(inverse_on(perm, patt))

# @profile
def flatten_(lst):
    """return a flattened list, ex. flatten_(3, 4, 2) == [2,3,1]
    slow implementation, O(n^2)"""
    f = [0] * len(lst)
    c = list(lst)
    c.sort()
    c.reverse
    for x in xrange(len(lst)):
        f[lst.index(c[x])] = x + 1
    return f

def smooth_out(lst):
    """return a flattened list of a list of lists, i.e. concats the lists inside lst
    ex. smooth_out([[[1,2]], [[2,1]]]) == [[1,2], [2,1]]"""
    return [i for sl in lst for i in sl] # fast python implementation


def avoids_by_in(perm, l, L, patt):
    """Returns a list of lists of subwords of perm of length l using dynamic programming
    L == is the original length"""
    if l == 1: # Base case
        k = [[[i]] for i in perm] # list of lists og lists
        return k
    else:
        smaller = avoids_by_in(perm, l-1, L, patt) # Solve for l - 1
        if smaller == False: return False # found banned subword
        bigger = [[]] * len(perm)
        f_patt = flatten_(patt[-l:])
        for i, v in enumerate(perm):            # Prepend for every value in perm
            if i < L - l: continue              # Too close to beginning of perm to make subword of length L
            elif i > len(perm) - l + 1: break   # subword must consist of values in perm in order
            f = smooth_out(smaller[i+1:])       # make a list of subwords out of list of list of subwords
            ith = []
            for subw in f:
                if (v < subw[0]) != (f_patt[0] < f_patt[1]): # if prepending item increasing or decreasing
                    continue # ca. 20% increase in speed for perm12, patt5
                # print "f_patt[-l:]=%s, f_patt=%s" % (f_patt[-l:], f_patt)
                new_subw = [v] + subw # prepend v to pattern
                # print "new_subw=%s, f_patt[-l:]=%s" % (new_subw, f_patt[-l:])
                if is_in(new_subw, f_patt):
                    # print "new_subw=%s is in f_patt[-l:]=%s" % (new_subw, f_patt[-l:])
                    if l == L: # pattern is in
                        # print "new_subw=%s, flat=%s is in f_patt[-l:]=%s" % (new_subw, flatten_(new_subw), f_patt[-l:])
                        # print "Returning False"
                        return False
                    else:
                        ith.append(new_subw)
                else:
                    pass
                    # print "new_subw=%s is not in patt[-l:]=%s" % (new_subw, patt[-l:])
            bigger[i] = ith # subwords
        if l == L:
            return True
        else:
            return bigger

def prt_2d(arr):
    print ""
    for row in arr:
        print row

# @profile
def avoids_it(perm, patt):
    """Returns a list of lists of subwords of perm of length l using dynamic programming
    L == is the original length"""
    # initializing method variables
    perm_len = len(perm)
    patt_len = len(patt)
    diff = perm_len - patt_len
    f_patts = [None] * patt_len
    sw = [[[] for i in range(perm_len)] for j in range(patt_len)]

    # set up
    for j in range(patt_len - 1, perm_len):
        sw[0][j].append([perm[j]])
    for i in range(patt_len):
        f_patts[patt_len - i - 1] = flatten_(patt[i:])
    # print f_patts[patt_len - 1]
    # prt_2d(sw)
    # iterate through 2d matrix
    for j in reversed(range(perm_len)): # column j
        for i in range(1, patt_len):       # row i
            # print i, j, diff
            if j + i < patt_len - 1: # top left corner
                continue
            if j + i > perm_len - 1: # bottom right corner
                continue
            # prt_2d(sw)
            # prepend perm[j] to every possible smaller subword
            for k in range(j + 1, perm_len):
                for sub in sw[i - 1][k]: # for every little subword to prepend to
                    if (perm[j] < sub[0]) != (f_patts[i][0] < f_patts[i][1]): # 20% increase
                        continue # heads of patt and new subword don't match
                    new_subw = [perm[j]] + sub
                    if is_in(new_subw, f_patts[i]):
                        if i == patt_len - 1: # Found total pattern in permutation
                            # print "Founds new_subw=%s in patt=%s" % (new_subw, patt)
                            return False
                        sw[i][j].append([perm[j]] + sub)
    return True # did not find pattern in permutation

class Patt(object):
    """My Pattern class"""
    def __init__(self, patt, perm_len):
        self.patt = patt
        self.perm_len = perm_len
        # initializing method variables
        self.patt_len = len(patt)
        self.f_patts = [None] * self.patt_len
        self.sw = [[[] for i in range(self.perm_len)] for j in range(self.patt_len)]

        # set up
        for i in range(self.patt_len):
            self.f_patts[self.patt_len - i - 1] = flatten_(self.patt[i:])

    # @profile
    def is_contained_in(self, perm):
        # print self.patt, perm
        if len(perm) != self.perm_len:
            print "Permutation of incompatible length, should be %d, received %d" %(self.perm_len, len(perm))
            return False
        for j in range(self.patt_len - 1, self.perm_len):
            self.sw[0][j] = []
            self.sw[0][j].append([perm[j]])
        # prt_2d(self.sw)
        # prt_2d(self.sw)
        for j in reversed(range(self.perm_len)):    # column j
            for i in range(1, self.patt_len):       # row i
                # print i, j
                if len(self.sw[i][j]) > 0:
                    self.sw[i][j] = [] # reuse initialized 2d matrix
                if j + i < self.patt_len - 1: # top left corner
                    continue
                if j + i > self.perm_len - 1: # bottom right corner
                    continue
                # prepend perm[j] to every possible smaller subword
                for k in range(j + 1, self.perm_len):
                    for sub in self.sw[i - 1][k]: # for every little subword to prepend to
                        if (perm[j] < sub[0]) != (self.f_patts[i][0] < self.f_patts[i][1]): # 20% increase
                            # print "Continuing"
                            continue # heads of patt and new subword don't match
                        new_subw = [perm[j]] + sub

                        # print new_subw, self.f_patts[i], is_in(new_subw, self.f_patts[i])
                        if is_in(new_subw, self.f_patts[i]):
                            if i == self.patt_len - 1: # Found total pattern in permutation
                                print "Founds patt=%s, subw=%s in perm=%s" % (self.patt, new_subw, perm)
                                return False
                            # print self.sw[i][j], new_subw
                            self.sw[i][j].append(new_subw)
                        # else do nothing. the subword is not in the pattern
                        # prt_2d(self.sw)

        return True # did not find pattern in permutation

    def __str__(self):
        return "Pattern %s" % self.patt

    def __repr__(self):
        return "Pattern %s" % self.patt

# patt = Patt([2, 1, 3, 4, 5], 9)
# for i in range(100):
#     k = [patt.is_contained_in(perm) for perm in perms]


def avoids2_(perm, patt):
    return avoids_by_in(perm, len(patt), len(patt), patt)

