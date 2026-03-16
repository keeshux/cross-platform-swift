// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

#pragma once

// primitive struct, easily managed in Swift
typedef struct {
    int num;
    char ch;
} cps_basic_struct;

// complex struct, transparent to Swift
typedef struct {
    const char *title;
    int nums[8];
    int (*fun)(const int *, size_t);
} cps_complex_struct;

const char *cps_complex_accumulate_string(const cps_complex_struct *ptr);

// opaque pointer to a similar complex struct, now hidden by C
typedef struct _cps_opaque_complex_struct *cps_opaque_struct;

cps_opaque_struct cps_opaque_create(const char *title,
                                    const int *nums,
                                    size_t nums_n,
                                    int (*fun)(const int *, size_t));
void cps_opaque_destroy(cps_opaque_struct ptr);
const char *cps_opaque_accumulate_string(const cps_opaque_struct ptr);
