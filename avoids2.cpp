#include <stdio.h>
#include "string.h"
#include "stdlib.h"

using namespace std;

int *inverse_on(int n, int *patt, int *perm) {
    int *inverse = new int[n];
    for (int i = 0; i < n; ++i)
    {
        inverse[perm[i] - 1] = patt[i];
    }
    return inverse;
}

bool is_sorted(int n, int *lst) {
    for (int i = 1; i < n; ++i)
    {
        if (lst[i] < lst[i - 1])
        {
            return false;
        }
    }
    return true;
}

bool is_in(int n, int *perm, int *patt) {
    return is_sorted(n, inverse_on(n, perm, patt));
}

void print_arr(int n, int *lst) {
    printf("[");
    for (int i = 0; i < n - 1; ++i)
    {
        printf("%d, ", lst[i]);
    }
    printf("%d]\n", lst[n - 1]);
}

int compare (const void * a, const void * b)
{
  return ( *(int*)a - *(int*)b );
}

int *flatten(int n, int *lst) {
    int *f = new int[n];
    int c[n];
    memcpy(c, lst, sizeof(c));
    qsort(c, n, sizeof(int), compare);
    print_arr(n, c);
    for (int i = 0; i < n; ++i)
    {
        int j = 0;
        for (; j < n; ++j) { // Find index of c[i]
            if (c[i] == lst[j]) {break; }
        }
        // printf("Found %d in pos %d\n", c[j], j);
        f[j] = i + 1;
    }

    return f;
}



int main(int argc, char const *argv[])
{
    int perm [] = {6,2,3,4};
    int patt [] = {4,1,2,3};
    int n = 4;
    int *inv = inverse_on(n, perm, patt);
    printf("Is in? %d\n", is_in(n, perm, patt));
    // print_arr(n, perm);

    print_arr(n, perm);
    int * f = flatten(n, perm);
    print_arr(n, f);
    return 0;
}