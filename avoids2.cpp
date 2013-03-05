#include <stdio.h>
#include <iostream>
#include <list>
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

bool avoids_it(int perm_len, int patt_len, int perm[], int patt[]) {
    list<int*> sw[patt_len][perm_len];
    for (int j = patt_len - 1; j < perm_len; ++j)
    {
        int t[] = {perm[j]};
        sw[0][j].push_back(t);

        for (list<int*>::iterator sub = sw[0][j].begin(); sub != sw[0][j].end(); ++sub)
        {
            ;
            // cout << (*sub)[0] << endl;
        }
    }

    for (int i = perm_len - 1; i > 0; --i)
    {
        for (int j = 1; j < patt_len - 1; ++j)
        {
            if (j + i < patt_len - 1) { continue; } // top-left corner
            if (j + i > perm_len - 1) { continue; } // bottom-right corner
            for (int k = j + 1; k < perm_len; ++k)
            {
                // cout << j << " " << i << " " << k << endl;
                for (list<int*>::iterator sub = sw[j - 1][k].begin(); sub != sw[j - 1][k].end(); ++sub)
                {
                    print_arr(j + 1, *sub);
                    int new_sw[j + 1];
                    new_sw[0] = perm[j];
                    memcpy((new_sw + 1), *sub, sizeof(new_sw) - 4);
                    print_arr(j + 1, new_sw);
                    sw[i][j].push_back(new_sw);
                    // int
                    // *sub.push_back()
                    // if ((perm[j] < (*sub)[0]))
                    // {
                    //     /* code */
                    // }
                    ;
                }
            }
        }
    }
}


int main(int argc, char const *argv[])
{
    int perm [] = {1,2,3,4,5};
    int patt [] = {1,2,3};
    int perm_len = 5;
    int patt_len = 3;
    avoids_it(perm_len, patt_len, perm, patt);
    int cpy[7];
    cpy[0] = 10;
    // memcpy((cpy + 1), perm, sizeof(cpy) - 4);
    // print_arr(7, cpy);
    // int *inv = inverse_on(n, perm, patt);
    // printf("Is in? %d\n", is_in(n, perm, patt));

    // print_arr(n, perm);

    // print_arr(n, perm);
    // int * f = flatten(n, perm);
    // print_arr(n, f);
    return 0;
}