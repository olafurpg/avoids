import sys

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

def prt_2d(arr):
    print ""
    for row in arr:
        print row

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
                        new_subw = [perm[j]] + sub
                        if (self.f_smaller[i] is not None and perm[j] < sub[self.f_smaller[i]]) or \
                                (self.f_larger[i] is not None and perm[j] > sub[self.f_larger[i]]):
                            continue
                        if i == self.patt_len - 1:
                            return True
                        self.sw[i][j].append(new_subw)

        return False # did not find pattern in permutation

    def __str__(self):
        return "Pattern %s" % self.patt

    def __repr__(self):
        return "Pattern %s" % self.patt

def avoids(perm, patt):
    """Initializes a Patt object and calls method is_contained_by to check for avoidance"""
    P = Patt(patt, len(perm))
    return P.is_contained_in(perm)

def avoiders(patt, perm_len):
    """Counts the number of permutations of length perm_len that avoid the given pattern patt"""
    patt = Patt(patt, perm_len)
    Perms = Permutations(perm_len)
    f = lambda perm : not patt.is_contained_in(perm)
    return Perms.filter(f).cardinality()

def expand(perm):
    """Reuturns a list of permutations made from perm"""
    new_perms = []
    n = len(perm) + 1
    for i in xrange(len(perm)):
        new_perms.append(perm[:i] + [n] + perm[i:])
    new_perms.append(perm + [n])
    return new_perms

def expand_avoiders(patt, perms):
    """returns a list of expansions of perms that avoid patt"""
    avs = []
    for perm in perms:
        if not patt.is_contained_in(perm):
            avs += expand(perm)
    return avs

def count(patt, n):
    """Returns the number of permutations of length n that avoid patt"""
    l = len(patt) + 1
    P = Permutations(l)
    p = Patt(patt, l)
    avoiders = expand_avoiders(p, P.list())
    for k in xrange(l + 1, n):
        p = Patt(patt, k)
        avoiders = expand_avoiders(p, avoiders)
    
    p = Patt(patt, n)
    avoiders = [perm for perm in avoiders if not p.is_contained_in(perm)]
    return len(avoiders)


