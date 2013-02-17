# perm =  [1,2,3,4,5]
av = set(tuple([2,1]))
class Node(object):
    """My Permutation Node Class, used to prevent unnecessary copying when calculating subwords"""
    def __init__(self, next, val, pos):
        self.next = next
        self.val = val
        self.pos = pos

    def __str__(self):
        if self.next:
            return "{}, {}".format(self.val, str(self.next))
        else:
            return "{}".format(self.val)

# n1 = Node(None, 5, 0)
# n2 = Node(n1, 4, 1)
# n3 = Node(n2, 3, 2)
# print n3
# n2 = Node(n1, 2, 1)

def subwords_ll(perm, l):
    """Calculates subwords using linked lists instead of """
    if l == 1:
        return [ Node(None, perm[i], i) for i in xrange(len(perm))]
    else:
        # print l
        smaller = subwords_ll(perm, l - 1)
        bigger = []
        for s in smaller:
            # print s
            for p in xrange(s.pos):
                bigger.append(Node(s, perm[p], p))

        return bigger

# for s in subwords_ll(perm, 2):
#     print s


def sw_(perm, l, avoids=set()):
    """Returns a list of lists of subwords of perm of length l using dynamic programming"""
    if l == 1: # Base case
        k = [[[i]] for i in perm] # list of lists og lists
        return k
    else:
        smaller = sw_(perm, l-1) # Solve for l - 1
        L = len(perm)
        bigger = [[]] * L
        # smaller.reverse()
        print smaller
        print perm
        for i in xrange(L): # for list in smaller
            ith = []
            for p in xrange(i): # for values in perm which can be prepended to list
                print "p=%d, i=%d" % (p, i)
                print "Smaller[i]=", smaller[i]
                for subw in smaller[i]: # for subword in list
                    new_subw = [perm[p]] + subw
                    check = tuple(flatten_(subw))
                    print new_subw, check, avoids
                    # print "Check =", check, check in avoids, avoids
                    # print subw, avoids, new_subw, 
                    if len(subw) > 0 and check not in avoids:
                        ith.append(new_subw)
            bigger[i] = ith
        # bigger = filter(lambda lst: len(lst) > 0, bigger)
        return bigger

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

def avs(patt):
    av = set()
    av.add(tuple([2,1]))
    av.add(tuple(patt))
    print av
    return av

def avoids_(perm, patt):
    av = avs(patt)
    return sw_(perm, len(patt), len(patt))


def sw(perm, l, L):
    """Returns a list of lists of subwords of perm of length l using dynamic programming
    L == is the original length"""
    if l == 1: # Base case
        k = [[[i]] for i in perm] # list of lists og lists
        return k
    else:
        smaller = sw(perm, l-1, L) # Solve for l - 1
        bigger = [[]] * len(perm)
        for i, v in enumerate(perm): # Prepend for every value in perm 
            if i < L - l: continue              # Too close to beginning of perm to make subword of length L
            elif i > len(perm) - l + 1: break   # subword must consist of values in perm in order
            f = flat(smaller[i+1:])
            prepend_v = lambda lst : [v] + lst
            # print "f=", f
            # for patt in f:
            #     print patt
            bigger[i] = map(prepend_v, f)
        # print bigger
        return bigger

def flat(lst):
    """return a flattened list of a list of lists, i.e. concats the lists inside lst"""
    return [i for sl in lst for i in sl] # fast python implementation

def subwords_(perm, l):
    """User front end, example use: subwords_([1,2,3], 2) == [[1,2],[1,3],[2,3]]"""
    return flat(sw(perm, l, l))
    