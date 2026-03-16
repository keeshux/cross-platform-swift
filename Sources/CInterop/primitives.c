// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

#include "primitives.h"

int cps_add(int a, int b) {
    return a + b;
}

int cps_accumulate(const int *v, size_t n) {
    int sum = 0;
    for (int i = 0; i < n; ++i) {
        sum += v[i];
    }
    return sum;
}

void cps_accumulate_and_store(const int *v, size_t n, int *result) {
    *result = cps_accumulate(v, n);
}
