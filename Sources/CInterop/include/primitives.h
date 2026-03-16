// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

#pragma once

#include <stdint.h>

// primitive types
int cps_add(int a, int b);

// pointers
int cps_accumulate(const int *v, size_t n);
void cps_accumulate_and_store(const int *v, size_t n, int *result);

// inline functions
static inline
int cps_inline_add(int a, int b) {
    return a + b;
}
