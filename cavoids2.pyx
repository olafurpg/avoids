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
        self.f_smaller = [None] * self.patt_len
        self.f_larger = [None] * self.patt_len
        self.sw = [[[] for i in range(self.perm_len)] for j in range(self.patt_len)]

        # set up
        for i in range(self.patt_len):
            p = self.patt_len - i - 1
            self.f_patts[p] = flatten_(self.patt[i:])
            front = self.f_patts[p][0]
            try: # smaller
                self.f_smaller[p] = self.f_patts[p].index(front - 1) - 1
            except:
                pass
            try: # larger
                self.f_larger[p] = self.f_patts[p].index(front + 1) - 1
            except:
                pass
            # print i + 1, p ,  self.f_patts[p], self.f_smaller[p], self.f_larger[p]



#     @profile
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
                        new_subw = [perm[j]] + sub
                        if (self.f_smaller[i] is not None and perm[j] < sub[self.f_smaller[i]]) or \
                                (self.f_larger[i] is not None and perm[j] > sub[self.f_larger[i]]):
                            continue
                        if i == self.patt_len - 1:
                            return False
                        self.sw[i][j].append(new_subw)

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

k = [[6, 5, 7, 8, 2, 3, 4, 1, 9], [5, 9, 1, 7, 6, 3, 4, 8, 2], [2, 6, 3, 7, 4, 5, 1, 8, 9], [3, 9, 6, 5, 4, 7, 1, 8, 2], [8, 3, 5, 2, 7, 4, 9, 1, 6], [2, 6, 8, 4, 1, 5, 9, 7, 3], [7, 5, 3, 2, 1, 6, 8, 9, 4], [6, 4, 7, 3, 1, 9, 5, 8, 2], [4, 9, 7, 5, 3, 2, 1, 8, 6], [5, 8, 4, 7, 3, 6, 2, 9, 1], [5, 8, 3, 1, 4, 2, 9, 6, 7], [3, 7, 8, 1, 4, 6, 5, 2, 9], [5, 9, 7, 4, 2, 1, 3, 6, 8], [8, 2, 3, 9, 6, 1, 5, 7, 4], [3, 2, 9, 6, 5, 8, 1, 4, 7], [3, 7, 8, 4, 5, 6, 2, 9, 1], [1, 8, 2, 9, 5, 3, 6, 4, 7], [7, 2, 6, 8, 3, 1, 9, 5, 4], [2, 6, 3, 9, 5, 4, 1, 8, 7], [9, 5, 6, 4, 8, 1, 7, 3, 2], [3, 4, 8, 2, 9, 5, 7, 1, 6], [8, 7, 2, 5, 9, 6, 3, 1, 4], [1, 9, 3, 7, 4, 6, 5, 8, 2], [7, 1, 6, 9, 2, 4, 3, 8, 5], [3, 2, 6, 5, 9, 7, 4, 8, 1], [6, 9, 1, 7, 8, 5, 2, 4, 3], [9, 1, 5, 4, 2, 8, 3, 6, 7], [1, 2, 6, 9, 8, 7, 3, 5, 4], [5, 7, 4, 3, 9, 8, 1, 6, 2], [5, 1, 9, 2, 7, 8, 3, 6, 4], [7, 5, 1, 9, 3, 2, 4, 8, 6], [3, 2, 5, 8, 7, 9, 1, 6, 4], [3, 8, 6, 4, 7, 9, 5, 1, 2], [7, 6, 1, 3, 8, 4, 2, 5, 9], [8, 4, 3, 1, 5, 7, 2, 9, 6], [6, 7, 2, 1, 8, 5, 4, 3, 9], [6, 7, 9, 3, 5, 4, 1, 2, 8], [8, 1, 3, 4, 9, 5, 6, 2, 7], [5, 2, 8, 6, 3, 9, 4, 1, 7], [8, 4, 7, 9, 2, 1, 3, 6, 5], [7, 8, 4, 6, 3, 5, 9, 1, 2], [1, 3, 5, 9, 7, 6, 4, 8, 2], [7, 2, 4, 3, 6, 8, 1, 5, 9], [3, 7, 6, 4, 1, 8, 2, 9, 5], [7, 4, 1, 3, 6, 8, 9, 5, 2], [4, 8, 6, 7, 3, 2, 5, 1, 9], [1, 9, 3, 2, 4, 6, 7, 5, 8], [5, 9, 8, 2, 6, 1, 3, 7, 4], [1, 3, 5, 4, 9, 7, 2, 8, 6], [4, 7, 2, 6, 9, 1, 3, 5, 8], [8, 4, 6, 2, 9, 1, 3, 5, 7], [7, 8, 6, 3, 1, 4, 2, 5, 9], [3, 6, 5, 4, 9, 1, 7, 8, 2], [4, 3, 6, 2, 7, 9, 1, 5, 8], [3, 4, 2, 9, 5, 8, 1, 7, 6], [9, 5, 8, 7, 2, 6, 1, 3, 4], [4, 8, 3, 2, 1, 5, 6, 9, 7], [5, 4, 6, 9, 7, 2, 8, 3, 1], [8, 1, 3, 6, 2, 7, 4, 9, 5], [5, 6, 7, 8, 1, 9, 3, 2, 4], [8, 3, 9, 6, 7, 4, 1, 5, 2], [1, 6, 3, 5, 9, 8, 7, 2, 4], [9, 2, 6, 3, 7, 1, 4, 8, 5], [1, 2, 3, 7, 9, 6, 4, 5, 8], [7, 1, 3, 2, 4, 8, 9, 5, 6], [1, 6, 3, 9, 5, 8, 7, 2, 4], [2, 7, 1, 4, 3, 9, 8, 6, 5], [2, 3, 6, 7, 1, 9, 4, 5, 8], [4, 5, 3, 7, 6, 8, 1, 2, 9], [2, 7, 3, 8, 9, 6, 5, 1, 4], [8, 7, 2, 3, 5, 4, 1, 6, 9], [2, 6, 5, 3, 7, 9, 4, 1, 8], [2, 1, 4, 5, 9, 6, 7, 3, 8], [3, 7, 5, 6, 1, 8, 9, 2, 4], [1, 2, 5, 3, 6, 7, 9, 8, 4], [6, 5, 2, 4, 7, 1, 8, 3, 9], [7, 8, 1, 9, 2, 3, 5, 6, 4], [1, 4, 9, 7, 5, 2, 6, 8, 3], [9, 7, 1, 8, 4, 3, 5, 2, 6], [5, 2, 3, 9, 6, 4, 8, 1, 7], [9, 5, 4, 8, 3, 6, 2, 1, 7], [5, 9, 8, 4, 7, 1, 2, 6, 3], [4, 6, 5, 7, 9, 8, 2, 1, 3], [8, 2, 7, 4, 9, 6, 3, 5, 1], [7, 6, 5, 8, 4, 3, 1, 2, 9], [3, 6, 5, 1, 8, 7, 9, 4, 2], [7, 4, 1, 3, 2, 9, 8, 6, 5], [5, 8, 6, 4, 7, 9, 2, 3, 1], [4, 1, 5, 8, 9, 7, 6, 2, 3], [2, 1, 6, 4, 8, 7, 9, 3, 5], [7, 9, 1, 3, 5, 6, 4, 2, 8], [4, 1, 7, 5, 9, 6, 3, 8, 2], [2, 6, 4, 9, 8, 1, 5, 7, 3], [4, 1, 9, 8, 6, 3, 7, 2, 5], [5, 6, 1, 9, 2, 8, 4, 7, 3], [8, 5, 3, 2, 6, 9, 1, 7, 4], [3, 2, 7, 9, 4, 5, 1, 8, 6], [3, 9, 5, 7, 1, 2, 4, 8, 6], [1, 7, 8, 6, 9, 4, 3, 5, 2], [9, 6, 8, 3, 7, 5, 4, 1, 2], [6, 9, 3, 1, 8, 5, 7, 4, 2], [1, 8, 2, 7, 6, 4, 3, 9, 5], [2, 4, 6, 7, 5, 1, 9, 8, 3], [5, 9, 4, 7, 6, 8, 2, 1, 3], [3, 5, 4, 1, 6, 7, 2, 9, 8], [3, 9, 2, 7, 1, 4, 8, 5, 6], [1, 6, 2, 9, 3, 5, 7, 8, 4], [5, 6, 7, 4, 8, 1, 2, 3, 9], [9, 2, 1, 4, 5, 7, 3, 8, 6], [7, 1, 3, 2, 9, 4, 6, 5, 8], [9, 8, 7, 3, 2, 4, 5, 1, 6], [7, 3, 9, 1, 4, 6, 2, 5, 8], [9, 3, 7, 1, 5, 2, 6, 8, 4], [5, 9, 8, 4, 6, 1, 3, 2, 7], [9, 2, 7, 8, 4, 3, 1, 5, 6], [9, 8, 1, 3, 5, 7, 4, 2, 6], [2, 3, 1, 6, 8, 4, 5, 7, 9], [4, 8, 5, 3, 9, 1, 7, 2, 6], [9, 1, 4, 8, 5, 2, 7, 6, 3], [9, 1, 2, 5, 8, 6, 7, 3, 4], [3, 1, 5, 7, 4, 6, 9, 2, 8], [3, 2, 9, 7, 6, 1, 8, 4, 5], [7, 4, 8, 3, 2, 6, 1, 9, 5], [2, 1, 8, 6, 9, 7, 5, 4, 3], [4, 5, 6, 8, 1, 3, 9, 7, 2], [2, 3, 4, 8, 9, 7, 5, 1, 6], [9, 7, 8, 5, 2, 3, 1, 4, 6], [2, 8, 5, 4, 7, 1, 9, 3, 6], [1, 8, 7, 2, 9, 6, 4, 5, 3], [9, 1, 2, 6, 7, 8, 4, 5, 3], [4, 1, 5, 7, 9, 2, 8, 3, 6], [7, 8, 4, 1, 2, 6, 3, 5, 9], [5, 3, 6, 9, 7, 2, 1, 8, 4], [8, 4, 6, 2, 3, 7, 5, 1, 9], [5, 9, 3, 2, 1, 8, 4, 6, 7], [2, 7, 9, 3, 4, 5, 8, 6, 1], [5, 2, 1, 6, 4, 3, 7, 9, 8], [4, 1, 7, 2, 5, 9, 6, 8, 3], [5, 9, 3, 2, 1, 4, 8, 7, 6], [7, 3, 8, 6, 2, 5, 9, 4, 1], [6, 5, 2, 9, 1, 4, 3, 7, 8], [3, 4, 2, 8, 9, 7, 1, 6, 5], [9, 4, 3, 6, 5, 2, 8, 1, 7], [6, 2, 9, 3, 7, 8, 5, 1, 4], [8, 4, 9, 5, 1, 7, 2, 3, 6], [4, 6, 7, 2, 8, 9, 5, 3, 1], [4, 2, 3, 8, 9, 6, 5, 7, 1], [9, 5, 7, 8, 6, 3, 4, 2, 1], [4, 9, 2, 1, 6, 5, 8, 3, 7], [5, 6, 7, 9, 8, 1, 2, 3, 4], [3, 6, 8, 5, 9, 4, 7, 1, 2], [8, 2, 1, 4, 5, 3, 6, 7, 9], [6, 2, 9, 3, 1, 4, 8, 7, 5], [3, 5, 6, 8, 4, 7, 1, 9, 2], [6, 8, 7, 4, 1, 9, 2, 5, 3], [5, 9, 6, 3, 4, 8, 1, 7, 2], [3, 9, 4, 2, 6, 7, 8, 1, 5], [9, 7, 2, 1, 3, 8, 6, 5, 4], [9, 7, 4, 6, 8, 3, 2, 1, 5], [2, 7, 5, 8, 4, 9, 1, 3, 6], [1, 4, 8, 5, 7, 3, 2, 9, 6], [6, 7, 4, 2, 1, 8, 5, 9, 3], [9, 1, 8, 2, 5, 6, 7, 4, 3], [2, 3, 9, 8, 6, 4, 7, 1, 5], [8, 4, 9, 5, 7, 1, 2, 3, 6], [3, 1, 2, 9, 7, 6, 8, 4, 5], [6, 5, 8, 7, 2, 4, 1, 9, 3], [4, 3, 8, 1, 6, 5, 2, 7, 9], [3, 4, 2, 8, 1, 7, 9, 6, 5], [6, 8, 2, 4, 1, 5, 9, 7, 3], [2, 4, 1, 3, 9, 6, 5, 8, 7], [1, 6, 5, 2, 9, 4, 7, 8, 3], [9, 6, 7, 1, 8, 4, 2, 5, 3], [1, 9, 7, 6, 4, 8, 2, 3, 5], [9, 5, 4, 2, 8, 6, 3, 1, 7], [9, 4, 3, 8, 6, 7, 2, 5, 1], [9, 3, 7, 2, 5, 8, 6, 1, 4], [1, 3, 5, 7, 4, 9, 2, 8, 6], [7, 1, 8, 6, 2, 5, 9, 4, 3], [6, 2, 1, 5, 8, 4, 7, 9, 3], [3, 6, 7, 8, 2, 9, 5, 4, 1], [2, 9, 1, 5, 6, 8, 4, 7, 3], [8, 5, 6, 3, 7, 4, 9, 2, 1], [1, 3, 9, 6, 4, 5, 2, 7, 8], [9, 3, 7, 1, 8, 2, 6, 5, 4], [6, 1, 3, 8, 5, 4, 2, 9, 7], [3, 7, 8, 1, 6, 2, 4, 9, 5], [9, 4, 3, 6, 8, 1, 5, 7, 2], [1, 4, 8, 9, 6, 3, 7, 5, 2], [6, 2, 3, 8, 7, 1, 4, 9, 5], [7, 6, 3, 1, 4, 9, 5, 2, 8], [1, 5, 9, 4, 6, 7, 8, 2, 3], [1, 3, 8, 9, 2, 7, 4, 5, 6], [9, 8, 2, 4, 5, 7, 6, 3, 1], [5, 9, 8, 1, 3, 2, 7, 6, 4], [5, 9, 1, 8, 6, 2, 4, 3, 7], [3, 9, 8, 1, 4, 2, 6, 7, 5], [9, 5, 3, 8, 4, 1, 2, 6, 7], [1, 5, 7, 6, 8, 3, 2, 9, 4], [6, 2, 7, 3, 1, 5, 4, 9, 8]]
patt = [2, 1, 5, 3, 4]
p = Patt(patt, 9)

my = [p.is_contained_in(u) for u in k]
