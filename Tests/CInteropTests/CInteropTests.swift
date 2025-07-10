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

import CInterop
import Testing

//
// Bear in mind, the tests prefixed with "unsafe" are precisely
// how NOT to do things. They may even succeed at times, but weird
// things will happen on the long run.
//
struct CInteropTests {

    @Test
    func add() {
        #expect(cps_add(10, 20) == 30)
        #expect(cps_inline_add(10, 20) == 30)
    }

    @Test
    func unsafeAccumulate() {
        let v: [Int32] = [10, 20, 30, 40]
        let pv = v.withUnsafeBytes {
            $0.bindMemory(to: Int32.self)
        }
        #expect(cps_accumulate(pv.baseAddress, v.count) == 100)
    }

    @Test
    func accumulate() {
        // the array type DOES make a difference, because Int is typically 64-bit
//        let v: [Int] = [10, 20, 30, 40]
        let v: [Int32] = [10, 20, 30, 40]
        v.withUnsafeBytes {
            // the bound type must match declaration
            let pv = $0.bindMemory(to: Int32.self)
            #expect(cps_accumulate(pv.baseAddress, v.count) == 100)
        }
    }

    @Test
    func accumulateAndStore() {
        let v: [Int32] = [10, 20, 30, 40]
        // trying to use Int here will give you legendary headaches
//        var result: Int = 0
        var result: Int32 = 0
        v.withUnsafeBytes {
            let pv = $0.bindMemory(to: Int32.self)
            cps_accumulate_and_store(pv.baseAddress, v.count, &result)
        }
        #expect(result == 100)
    }
}
