
# for s in subwords_node(perm, 2):
#     print s

def inverse(perm):
    inv = [0] * len(perm)
    for i in range(len(perm)):
        print i, perm, inv
        inv[perm[i] - 1] = perm[i]
    return inv

def flat_(sw):
    k1 = lambda n : n[1]
    k0 = lambda n : n[0]
    z = zip(sw, range(1,len(sw) + 1))
    print z
    z.sort(key = k0)
    print z

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
    """return a flattened list of a list of lists, i.e. concats the lists inside lst"""
    return [i for sl in lst for i in sl] # fast python implementation

def sw(perm, l, L, banned=set()):
    """Returns a list of lists of subwords of perm of length l using dynamic programming
    L == is the original length"""
    if l == 1: # Base case
        k = [[[i]] for i in perm] # list of lists og lists
        return k
    else:
        smaller = sw(perm, l-1, L, banned) # Solve for l - 1
        # if l < 5:
        #     print smaller
        bigger = [[]] * len(perm)
        for i, v in enumerate(perm): # Prepend for every value in perm
            if i < L - l: continue              # Too close to beginning of perm to make subword of length L
            elif i > len(perm) - l + 1: break   # subword must consist of values in perm in order
            f = smooth_out(smaller[i+1:])
            ith = []
            for patt in f:
                new_subw = [v] + patt # prepend v to pattern
                ith.append(new_subw)
            bigger[i] = ith # subwords
        return bigger

def avoids_sw(perm, l, L, banned=set()):
    """Returns a list of lists of subwords of perm of length l using dynamic programming
    L == is the original length"""
    if l == 1: # Base case
        k = [[[i]] for i in perm] # list of lists og lists
        return k
    else:
        smaller = avoids_sw(perm, l-1, L, banned) # Solve for l - 1
        bigger = [[]] * len(perm)
        for i, v in enumerate(perm): # Prepend for every value in perm
            if i < L - l: continue              # Too close to beginning of perm to make subword of length L
            elif i > len(perm) - l + 1: break   # subword must consist of values in perm in order
            f = smooth_out(smaller[i+1:]) # make a list of subwords out of list of list of subwords
            ith = []
            for patt in f:
                new_subw = [v] + patt # prepend v to pattern
                check = tuple(flatten_(new_subw))
                if check not in banned:
                    # print "Subword %s is allowed %s" % (new_subw, banned)
                    ith.append(new_subw)
                else:
                    if l == L:
                        # pass
                        # print "Permutation %s contains pattern %s at %s" % (perm, check, new_subw)
                        return false
                    # print "Pattern avoids subword %s, look no further here" % (new_subw)
            bigger[i] = ith # subwords
        # if l == L:
        #     return True
        return bigger

def avoids_pos_(perm, l, L, banned=set(), pos = None):
    """Returns a list of lists of subwords of perm of length l using dynamic programming
    L == is the original length"""
    if l == 1: # Base case
        k = [[[i]] for i in perm] # list of lists og lists
        return k
    else:
        smaller = avoids_pos_(perm, l-1, L, banned, pos) # Solve for l - 1
        if smaller == False: return False # found banned subword
        bigger = [[]] * len(perm)
        for i, v in enumerate(perm): # Prepend for every value in perm
            if i > len(perm) - l + 1: break   # reached end, no possible subwords from this position
            if pos is not None and l == L and i != pos: # only prepend subwords containing pos
                print "pos = %d, i = %d, l = %d, continuing" % (pos, i, l)
                continue
            f = smooth_out(smaller[i + 1:]) # make a list of subwords out of list of list of subwords
            ith = []
            for patt in f:
                new_subw = [v] + patt # prepend v to pattern
                if i == pos: # only check in banned if we are looking for this position
                    check = tuple(flatten_(new_subw))
                    # print "looking for check=%s in banned=%s" % (check, banned)
                    if check in banned:
                        print "Subword %s is not allowed, banned=%s" % (new_subw, banned)
                        return False
                ith.append(new_subw) # else just append
            bigger[i] = ith # subwords
        if l == L:
            return True
        else:
            return bigger

def avs(patt):
    av = set()
    # av.add(tuple([1, 2])) # used for testing, could basically add any tuple
    # av.add(tuple([1, 2, 3])) # used for testing, could basically add any tuple
    # av.add(tuple([2, 3, 1])) # used for testing, could basically add any tuple
    # av.add(tuple([2, 1, 3])) # used for testing, could basically add any tuple
    av.add(tuple(patt))
    return av

def avoids_(perm, patt):
    banned = avs(patt)
    return avoids_sw(perm, len(patt), len(patt), banned)


def subwords_(perm, l):
    """User front end, example use: subwords_([1,2,3], 2) == [[1,2],[1,3],[2,3]]"""
    return smooth_out(sw(perm, l, l))
