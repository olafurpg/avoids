import bisect # for simple ZipList insert

# import timeit


# perm =  [1,2,3,4,5]
class ZipList(object):
    """List for permutation comparison, list of tuples (a,b) sorted by b"""
    def __init__(self): #  , a=None, b=None, next=None):
        self.lst = []
    #     self.a = a
    #     self.b = b
    #     self.next = next
    def insert(self, a, b):
        bisect.insort(self.lst,(a, b))
        return self
    def insert_perms(self, a, b):
        if len(a) != len(b):
            return "Permutations %s and %s must be of equal length" % (a, b)
        ahead = a.head
        bhead = b.head
        while ahead and ahead.val:
            self.insert(ahead.val, bhead.val)
            ahead = ahead.next
            bhead = bhead.next
        return self


    # def insert(self, a, b):
    #     if not self.b: # empty list
    #         self.b = b
    #         self.a = a
    #         # self.next = None # it is already
    #     elif self.b < b: # b should go further
    #         try :
    #             self.next.insert(a, b) # insert deeper into the list
    #         except:
    #             self.next = ZipList(a, b)
    #     else:
    #         try:
    #             self.next.insert()
    #         except:
    #             self.next = ZipList(self.a, self.b)
    #             self.a = a
    #             self.b = b
    def __str__(self):
        return str(self.lst)
    def is_b_sorted(self):
        for i in range(1,len(self.lst)):
            if self.lst[i][1] < self.lst[i - 1][1]:
                return False
        return True

        # if self.next:
        #     return "({},{})::{}".format(self.a, self.b, self.next)
        # else:
        #     return "({}, {})::End".format(self.a, self.b)

def make_zip_list(sw, perm):
    """Takes in two permutations"""
    if len(sw) != len(perm):
        return "Incompatible lengths!"
    z = ZipList()
    phead = perm.head
    shead = sw.head
    while phead.val:
        print shead.val, phead.val
        z.insert(shead, phead)
        shead = shead.next
        phead = phead.next
    return ZipList()



class Node(object):
    """My Permutation Node Class, used to prevent unnecessary copying when calculating subwords"""
    def __init__(self, next=None, val=None, pos=None):
        self.next = next
        self.val = val
        self.pos = pos


    def __str__(self):
        if self.next and self.next.val:
            return "{} {}".format(self.val, str(self.next))
        elif self.val:
            return "{}".format(self.val)
        else:
            return ""

class Perm(object):
    """My functional permutation class"""
    def __init__(self, perm_or_node):
        self.length = 0
        try:
            if type(perm_or_node) == type([]): # Would like to avoid typecasting
                self.perm = list(perm_or_node) # copy list
                perm_or_node.reverse()
                self.head = Node()
                for i in range(len(perm_or_node)):
                    self.head = Node(self.head, perm_or_node[i], len(perm_or_node) - (i + 1))
                    self.length += 1
            else: # type is Node
                self.head = perm_or_node
                self.perm = []
                while perm_or_node:
                    self.length += 1
                    self.perm.append(perm_or_node.val)
                    perm_or_node = perm_or_node.next
        except:
            print "Permutation  %s of type %s invalid" % (perm_or_node, type(perm_or_node))



    def __str__(self):
        return str(self.head)
    def __len__(self):
        return self.length

    def list(self):
        perm = []
        head = self.head
        while head:
            perm.append(head.val)
            head = head.next
        return perm

    def subwords(self, k):
        subs = self._subwords(k)
        permute = lambda node : Perm(node)
        return map(permute, subs)

    def avoids(self, patt):
        if type(patt) == type([]):
            patt = Perm(patt)
        # print "Patt len before %d" % len(patt)
        subs = self.subwords(len(patt))
        for sub in subs:
            # print "Patt len %d" % len(patt)
            if inside(sub, patt):
                # print "Patt %s" % patt
                # print inside(sub, patt)
                # print len(sub), len(patt)
                # print "Subword %s contains pattern %s" % (sub, patt)
                return False
        return True

    def _subwords(self, l):
        """Calculates subwords using linked lists"""
        if l == 1:
            return [ Node(None, self.perm[i], i) for i in xrange(len(self.perm))]
        else:
            # print l
            smaller = self._subwords( l - 1)
            bigger = []
            for s in smaller:
                # print s
                for p in xrange(s.pos):
                    bigger.append(Node(s, self.perm[p], p))

            return bigger


def inside(subw, patt):
    """Returns whether the pattern can be found in the subword
    the subword must be of the same length as pattern """

    if len(subw) != len(patt):
        print len(subw), len(patt)
        return "Incompatible lengths, %s and %s" % (subw, patt)
    z = ZipList()
    z.insert_perms(subw, patt)
    return z.is_b_sorted()



# n1 = Node(None, 9, 0)
# n2 = Node(n1, 4, 1)
# n3 = Node(n2, 7, 2)
# # print n3
# m1 = Node(None, 2, 0)
# m2 = Node(m1, 1, 1)
# m3 = Node(m2, 3, 2)
# # n2 = Node(n1, 2, 1)

# z = ZipList()
# z.insert(n2.val, m2.val)
# z.insert(n1.val, m1.val)
def benchmark_list(n, l):
    q = [Permutations(n).random_element() for i in range(l)]
    q = map(list, q)
    # q = Permutations(n).random_element()
    return q

tests = 30
patt_len = 7
perm_len = 14
regular = Permutations(perm_len).random_element()
functional = Perm(list(regular))
test_patterns = benchmark_list(patt_len, tests)

def reg(perm, patts):
    return [perm.avoids(u) for u in patts]

def func(perm, patts):
    return [perm.avoids(u) for u in patts]


# perm_len = 5
# regular = Permutations(perm_len).random_element()
# functional = Perm(list(regular))
# test_patterns = benchmark_list(tests, patt_len)
# print "Patterns: %s" % test_patterns
# print "Permutation: %s" % regular
# print "Running test for regular Permutation"
# timeit.timeit("reg(regular, test_patterns)", setup="from __main__ import reg")
# print "Running test for functional Permutation"
# timeit.timeit("func(functional, test_patterns)", setup="from __main__ import func")







