# perm =  [1,2,3,4,5]

class Node(object):
    """My Permutation Node Class """
    def __init__(self, next, val, pos):
        self.next = next
        self.val = val
        self.pos = pos

    def __str__(self):
        if self.next:
            return "{}, {}".format(self.val, str(self.next))
        else:
            return "{}".format(self.val)

n1 = Node(None, 5, 0)
n2 = Node(n1, 4, 1)
n3 = Node(n2, 3, 2)
# print n3
# n2 = Node(n1, 2, 1)

def sub(perm, l):
    if l == 1:
        return [ Node(None, perm[i], i) for i in xrange(len(perm))]
    else:
        # print l
        smaller = sub(perm, l - 1)
        bigger = []
        for s in smaller:
            # print s
            for p in xrange(s.pos):
                bigger.append(Node(s, perm[p], p))

        return bigger

# for s in sub(perm, 2):
#     print s


def sw(perm, l, L):
    """Returns subwords of perm of length l by using dynamic programming, L == is the original length"""
    if l == 1: # Base case
        k = [[[i]] for i in perm]
        return k
    else:
        smaller = sw(perm, l-1, L) # Solve for l - 1
        bigger = [[]] * len(perm)
        for i, v in enumerate(perm): # Prepend for every value in perm 
            if i < L - l:
                continue
            elif i > len(perm) - l + 1:
                break
            f = flat(smaller[i+1:])
            prepend = lambda lst : [v] + lst
            bigger[i] = map(prepend, f)
        # print bigger
        return bigger

def flat(lst):
    return [i for sl in lst for i in sl]

def subwords_(perm, l):
    return flat(sw(perm, l, l))
    