
# for s in subwords_node(perm, 2):
#     print s

def inverse_on(patt, perm):
    inv = [0] * len(perm)
    for i in range(len(perm)):
        # print i, perm, inv
        inv[perm[i] - 1] = patt[i]
    return inv

def is_sorted(lst):
    for i in range(1, len(lst)):
        if lst[i] < lst[i - 1]:
            return False
    return True

def is_in(perm, patt):
    # print "Is perm=%s in patt=%s ?" % (perm, patt)
    return is_sorted(inverse_on(perm, patt))


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

def avoids_sw(perm, l, L, banned=set(), incrementing_behind = None):
    """Returns a list of lists of subwords of perm of length l using dynamic programming
    L == is the original length"""
    if l == 1: # Base case
        k = [[[i]] for i in perm] # list of lists og lists
        return k
    else:
        smaller = avoids_sw(perm, l-1, L, banned, incrementing_behind) # Solve for l - 1
        if smaller == False: return False # found banned subword
        bigger = [[]] * len(perm)
        for i, v in enumerate(perm): # Prepend for every value in perm
            if i < L - l: continue              # Too close to beginning of perm to make subword of length L
            elif i > len(perm) - l + 1: break   # subword must consist of values in perm in order
            f = smooth_out(smaller[i+1:]) # make a list of subwords out of list of list of subwords
            ith = []
            for patt in f:
                # if l == 2:
                #     print "v=%d, patt=%s, incrementing_behind=%s" % (v, patt[0], incrementing_behind)
                #     if incrementing_behind is True and v < patt[0]:
                #         print "incrementing behind, skiping new_subw=[%d, %d]" % (v, patt[0])
                #         continue
                #     if incrementing_behind is False and v > patt[0]:
                #         print "decrementing behind, skiping new_subw=[%d, %d]" % (v, patt[0])
                #         continue
                new_subw = [v] + patt # prepend v to pattern
                if not is_in(new_subw, perm[-l:]):
                    ith.append(new_subw)
                elif l == L: # pattern is in
                    return False
                # check = tuple(flatten_(new_subw))
                # if check not in banned:
                #     # look if a subword of this subwords contains a banned pattern
                #     pos = len(new_subw) - 1
                #     if avoids_pos_(new_subw, pos, pos, banned, 0):
                # else:
                #     if l == L:
                #         # print "Permutation %s contains pattern %s at %s" % (perm, check, new_subw)
                #         return false
                    # print "Pattern avoids subword %s, look no further here" % (new_subw)
            bigger[i] = ith # subwords
        if l == L:
            return True
        else:
            return bigger

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
        for i, v in enumerate(perm): # Prepend for every value in perm
            if i < L - l: continue              # Too close to beginning of perm to make subword of length L
            elif i > len(perm) - l + 1: break   # subword must consist of values in perm in order
            f = smooth_out(smaller[i+1:]) # make a list of subwords out of list of list of subwords
            ith = []
            for subw in f:
                new_subw = [v] + subw # prepend v to pattern
                # print "new_subw=%s, f_patt[-l:]=%s" % (new_subw, f_patt[-l:])
                if is_in(new_subw, f_patt[-l:]):
                    # print "new_subw=%s is in f_patt[-l:]=%s" % (new_subw, f_patt[-l:])
                    ith.append(new_subw)
                    if l == L: # pattern is in
                        print "new_subw=%s is in f_patt[-l:]=%s" % (new_subw, f_patt[-l:])
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
                # print "pos = %d, i = %d, l = %d, continuing" % (pos, i, l)
                continue
            f = smooth_out(smaller[i + 1:]) # make a list of subwords out of list of list of subwords
            ith = []
            for patt in f:
                new_subw = [v] + patt # prepend v to pattern
                if i == pos: # only check in banned if we are looking for this position
                    check = tuple(flatten_(new_subw))
                    # print "looking for check=%s in banned=%s" % (check, banned)
                    if check in banned:
                        # print "Found sw = %s within sw = %s" % (new_subw, perm)
                        return False
                ith.append(new_subw) # else just append
            bigger[i] = ith # subwords
        # if l == L:
        #     if len(smooth_out(bigger)) == 0
        #         return bigger

        # else:
        return bigger

def avs(patts):
    av = set()
    for patt in patts:
        av.add(tuple(patt))
    # print "av=%s" % av
    return av


def subwords_avoiding_(perm, l, patts):
    """Return a list of the subwords of perm, of length l, which avoid the banned patterns in patts"""
    banned = avs(patts)
    incrementing_behind = patts[-1][-1] > patts[-1][-2]
    lst = avoids_sw(perm, l, l, banned, incrementing_behind)
    if lst is False or lst is True:
        return lst
    else:
        return smooth_out(lst)

def avoids_(perm, patt):
    banned = avs(patt)
    return avoids_sw(perm, len(patt), len(patt), banned)


def subwords_(perm, l):
    """User front end, example use: subwords_([1,2,3], 2) == [[1,2],[1,3],[2,3]]"""
    return smooth_out(sw(perm, l, l))
