import sys

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

def is_sorted(lst):
    """returns true if lst is sorted, false otherwise"""
    for i in range(1, len(lst)):
        if lst[i] < lst[i - 1]:
            return False
    return True

def is_in(perm, patt):
    # print "Is perm=%s in patt=%s ?" % (perm, patt)
    return is_sorted(inverse_on(perm, patt))


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
                    ith.append(new_subw)
                    if l == L: # pattern is in
                        # print "new_subw=%s, flat=%s is in f_patt[-l:]=%s" % (new_subw, flatten_(new_subw), f_patt[-l:])
                        # print "Returning False"
                        return False
                else:
                    pass
                    # print "new_subw=%s is not in patt[-l:]=%s" % (new_subw, patt[-l:])
            bigger[i] = ith # subwords
        if l == L:
            return True
        else:
            return bigger

def avoids2_(perm, patt):
    return avoids_by_in(perm, len(patt), len(patt), patt)
