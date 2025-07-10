//
// MIT License
//
// Copyright (c) 2025 Davide De Rosa
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

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
