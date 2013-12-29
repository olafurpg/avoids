"""
A Pattern module for Sage Mathematics

Contains fast implementations of methods Pattern.subwords using
dynamic programming and Pattern.avoid by reducing redundant computations.
"""
# TODO: Profiling
# TODO: Test cases
# TODO: Calculate inverse of f_patts instead of ugly try/catch
# TODO: lst representation of Pattern class
# TODO: mesh pattern avoidance


def flatten_(lst):
    """Return a flattened list

    Slow implementation, O(n^2)

    >>> flatten_(3, 8, 2)
    [2,3,1]
    """
    f = [0] * len(lst)
    c = list(lst)
    c.sort()
    c.reverse
    for x in xrange(len(lst)):
        f[lst.index(c[x])] = x + 1
    return f

def avoids_2(perm, patt):
    """Pattern avoidance. Returns true if perm avoids patt, false otherwise."""
    return Pattern(patt).avoided_by(perm)

class Pattern(object):
    """A Classical Pattern

Contains a rich interface that is simple to use."""
    def __init__(self, pattern):
        self.pattern = pattern
        self.patt_lens = set()
        self.patts = {}

    def get_patt(self, perm):
        """Patt object with corresponding length for perm

        >>> Pattern([1,2,3]).get_patt([1,2,3,4])
        LengthPattern [1, 2, 3] with length 4"""
        if not len(perm) in self.patt_lens:
            self.patt_lens.add(len(perm))
            self.patts[len(perm)] = LengthPattern(self.pattern, len(perm))
        return self.patts[len(perm)]

    def subwords(self, perm):
        """Generator for subwords of perm containing Pattern

        >>> [perm for perm in Pattern([1,2,3]).subwords([1,5,2,4,3])]
        [[1, 2, 4], [1, 2, 3]]"""
        patt = self.get_patt(perm)
        return patt.subwords(perm)

    def subwords_list(self, perm):
        """List of subwords of perm containing Pattern

        >>> Pattern([1,2,3]).subwords_list([1,5,2,4,3])
        [[1, 2, 4], [1, 2, 3]]"""
        return list(subword for subword in self.subwords(perm))

    def subwords_print(self, perm):
        """Print out subwords of perm containing Pattern"""
        for subword in self.subwords(perm):
            print subword

    def avoided_by(self, perm):
        """True if perm avoids pattern, false otherwise

        >>> Pattern([1,2,3]).avoided_by([4,3,1,2,5])
        False
        >>> Pattern([1,2,3]).avoided_by([5,4,3,1,2])
        True"""
        for subword in self.subwords(perm):
            # we only need one subword
            return False
        return True

    def avoiders(self, n):
        """Generator for permutations of length n that avoid Pattern

        Fast implementations, it does not iterate through all permuatation of length
        n. Instead, it begins with all permutations of length one larger than the
        given pattern and then expands only those permutations that avoid the pattern.

        >>> [perm for perm in Pattern([1,2,3]).avoiders(4)]
        [[1, 4, 3, 2],
        [2, 1, 4, 3],
        [2, 4, 1, 3],
        [2, 4, 3, 1],
        [3, 1, 4, 2],
        [3, 2, 1, 4],
        [3, 2, 4, 1],
        [3, 4, 1, 2],
        [3, 4, 2, 1],
        [4, 1, 3, 2],
        [4, 2, 1, 3],
        [4, 2, 3, 1],
        [4, 3, 1, 2],
        [4, 3, 2, 1]]"""
        int(n)
        def derived_avoiders(perm):
            """docstring for derived_avoiders"""
            if self.avoided_by(perm):
                if len(perm) == n:
                    yield perm
                else:
                    for new_perm in self.expanded(perm):

                        derived_avoiders(new_perm)

        for perm in Permutations(len(self.pattern) + 1):
            for deriv in derived_avoiders(perm):
                yield deriv

    def avoiders_cardinality(self, n):
        """Count the number of permutations of length n that avoid Pattern

        >>> Pattern([1,2,3]).avoiders_cardinality(10)
        16796"""
        return len(self.avoiders_list(n))

    def avoiders_list(self, n):
        """List of permutations of length n that avoid Pattern

        >>> Pattern([1,2,3]).avoiders_list(4)
        [[1, 4, 3, 2],
        [2, 1, 4, 3],
        [2, 4, 1, 3],
        [2, 4, 3, 1],
        [3, 1, 4, 2],
        [3, 2, 1, 4],
        [3, 2, 4, 1],
        [3, 4, 1, 2],
        [3, 4, 2, 1],
        [4, 1, 3, 2],
        [4, 2, 1, 3],
        [4, 2, 3, 1],
        [4, 3, 1, 2],
        [4, 3, 2, 1]]"""
        return list(self.avoiders(n))

    def expanded(self, perm):
        """Generator for exansions of perm

        >>> [perm for perm in expand([1,2,3])]
        [[4, 1, 2, 3], [1, 4, 2, 3], [1, 2, 4, 3], [1, 2, 3, 4]]
        """
        n = len(perm) + 1
        for i in xrange(len(perm)):
            yield perm[:i] + [n] + perm[i:]
        yield perm + [n]

    def clear_cache(self):
        """Clear memory allocated by self

        >>> p.clear_cache()
        Cache cleared"""
        self.patt_lens = set()
        self.patts = {}
        print "Cache cleared"

    def __str__(self):
        return "Pattern %s" % self.pattern

    def __repr__(self):
        return "Pattern %s" % self.pattern


class LengthPattern(object):
    """A Classical Pattern for comparison with permutations of a specific length

More restricted interface, see Pattern class for better interface."""
    def __init__(self, patt, perm_len):
        """Initialise LengthPattern with a classical pattern patt (list) and integer length perm_len (int)

        >>> LengthPattern([1,2,3,4], 10)
        LengthPattern [1, 2, 3, 4] with length 10"""
        # Confirm that patt is a valid permutation
        Permutation(patt)

        if perm_len <= len(patt):
            s = "Permutation length has to be larger than Pattern length"
            raise ValueError(s)

        self.patt = patt
        self.perm_len = perm_len

        # initializing method variables
        self.patt_len = len(patt)
        self.f_patts = [None] * self.patt_len
        self.below = [None] * self.patt_len
        self.above = [None] * self.patt_len

        # 2d array of subwords
        # patt_len nr. of rows
        # perm_len nr. of columns
        self.subword_matrix = [[[] for i in xrange(self.perm_len)] for j in xrange(self.patt_len)]

        # ugly block
        # find out index of value above and below i
        for i in xrange(self.patt_len):
            p = self.patt_len - i - 1
            self.f_patts[p] = flatten_(self.patt[i:])
            front = self.f_patts[p][0]
            try:  # smaller
                self.below[p] = self.f_patts[p].index(front - 1) - 1
            except:
                pass
            try:  # larger
                self.above[p] = self.f_patts[p].index(front + 1) - 1
            except:
                pass

    def subwords(self, perm):
        """Generator for subwords of perm that contain Patt

        Fast implementation, might allocate a lot of memory

        >>> [perm for perm in LengthPattern([1,2,3], 4).subwords([1,2,3,4])]
        [[2, 3, 4], [1, 2, 3], [1, 2, 4], [1, 3, 4]]"""

        # Confirm that perm is a valid Permutation
        Permutation(perm)

        # Confirm that perm is of compatible length
        if len(perm) != self.perm_len:
            raise Exception("""Permutation of incompatible length
    should be %d but received %d""" % (self.perm_len, len(perm)))

        subword_matrix = self.subword_matrix  # simplify code

        # First row
        for j in xrange(self.patt_len - 1, self.perm_len):
            subword_matrix[0][j] = []
            subword_matrix[0][j].append([perm[j]])

        # Following rows
        for j in reversed(xrange(self.perm_len)):    # column j
            for i in xrange(1, self.patt_len):       # row i
                # reuse initialized 2d matrix
                if len(subword_matrix[i][j]) > 0:
                    subword_matrix[i][j] = []

                # Skip corners of the matrix
                if j + i < self.patt_len - 1:  # top left corner
                    continue
                if j + i > self.perm_len - 1:  # bottom right corner
                    continue

                # prepend perm[j] to every possible smaller subword
                for k in xrange(j + 1, self.perm_len):
                    # for every little subword to prepend to
                    for subword in subword_matrix[i - 1][k]:
                        below = self.below[i]
                        if below is not None and perm[j] < subword[below]:
                            continue

                        above = self.above[i]
                        if above is not None and perm[j] > subword[above]:
                            continue

                        new_subw = [perm[j]] + subword

                        # length of patt reached?
                        if i == self.patt_len - 1:
                            yield new_subw
                        else:
                            subword_matrix[i][j].append(new_subw)

        raise StopIteration()  # No more subwords

    def __str__(self):
        return "LengthPattern %s with length %s" % (self.patt, self.perm_len)

    def __repr__(self):
        return "LengthPattern %s with length %s" % (self.patt, self.perm_len)

def G(w):
    """
    The graph/diagram of the permutation w
    """
    return [ (x+1,y) for (x,y) in enumerate(w) ]


def avoids_mpat(perm, pat, R=[]):
    """
    Returns False if (pat, R) occurs in perm, otherwise returns True
    """

    k = len(pat)
    n = len(perm)

    if k>n: return True

    pat = G(pat)
    perm = G(perm)
    for H in Subwords(perm, k):

        X = dict(G(sorted(i for (i,_) in H)))
        Y = dict(G(sorted(j for (_,j) in H)))
        if H == [ (X[i], Y[j]) for (i,j) in pat ]:
            X[0], X[k+1] = 0, n+1
            Y[0], Y[k+1] = 0, n+1
            shady = ( X[i] < x < X[i+1] and Y[j] < y < Y[j+1]
                      for (i,j) in R
                      for (x,y) in perm
                      )
            if not any(shady):
                return False
    return True

# Lausn frá Helga Kristvin, STFO

def lt(val, lst):
    return len(filter(lambda n: n, map(lambda n: val > n, lst)))


def cat_shadings(permutation, perm, idx=False):
    buck = [[[] for _ in range(1 + len(perm))] for i in range(1 + len(perm))]
    xl = 0

    idx = []

    for i in permutation:
        if not xl >= len(perm) and i == perm[xl]:
            xl += 1
            continue

        yl = lt(i, perm)
        idx.append((xl, yl))
        buck[xl][yl].append(i)

    if idx:
        return (buck, idx)
    return buck


def matches_shading(shading, permutation, perm):
    buck = cat_shadings(permutation, perm)
    for (x, y) in shading:
        if buck[x][y]:
            return False

    return True


def shade(permutation, perm):
    (sh, idx) = cat_shadings(permutation, perm, True)
    return idx


def mesh_avoids(permutation, pattern):
    pattern, shading = pattern

    if len(pattern) > len(permutation):
        return True

    m = len(pattern)

    p_inv = [0] * m
    n = 1
    for v in pattern:
        p_inv[v-1] = n
        n += 1

    for perm in Subwords(permutation, m):
        nm = perm[p_inv[0] - 1]
        for p in p_inv[1:]:
            n = perm[p - 1]
            if nm < n:
                nm = n
            else:
                break
        else:
            if matches_shading(shading, permutation, perm):
                return False
    return True


def is_sorted(lst):
    for i in range(len(lst)-1):
        if lst[i] > lst[i+1]:
            return False
    return True

def prob7(_S, max_len=None):
    S = set(_S)
    b = set([])
    if max_len == None:
        max_len = max(map(len, _S))

    min_len = min(map(len, _S))

    for i in range(1, max_len+1):
        for p in Permutations(i):
            if p not in S and all(map(lambda n: mesh_avoids(p, (n, [])), b)):
                b.add(p)

    shadings = {}

    for i in S:
        for p in b:
            shadings.setdefault(p, [])
            if not mesh_avoids(i, (p, [])):
                shadings[p].append(shade(i, p))

    return shadings.items()


def is_sorted(lst):
    for i in range(len(lst)-1):
        if lst[i] > lst[i+1]:
            return False
    return True


