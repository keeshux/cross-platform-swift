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
import Foundation
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
        // it's easier to match C type
        //        let v: [Int] = [10, 20, 30, 40]
        let v: [Int32] = [10, 20, 30, 40]
        v.withUnsafeBufferPointer {
            #expect(cps_accumulate($0.baseAddress, v.count) == 100)
        }
    }

    @Test
    func accumulateAndStore() {
        // trying to use Int here will give you decent headaches
        let v: [Int32] = [10, 20, 30, 40]
//        var result: Int = 0
        var result: Int32 = 0
        v.withUnsafeBufferPointer {
            cps_accumulate_and_store($0.baseAddress, v.count, &result)
        }
        #expect(result == 100)
    }

    @Test
    func basicStructs() {
        var sut = cps_basic_struct()
        sut.num = 100
        sut.ch = 50
        #expect(Int(sut.num) + Int(sut.ch) == 150)
    }

    // the struct is entirely managed by Swift
    @Test
    func complexStructs() {
        let v: [Int32] = [10, 20, 30, 40]
        let title = "Hello"
        let string = v.withUnsafeBufferPointer { pv in
            var sut = cps_complex_struct()

            // set the function pointer, and C functions are not Swift closures
            sut.fun = cps_accumulate

            // copy the Swift vector to the nums C array
            _ = withUnsafeMutablePointer(to: &sut.nums) {
                $0.withMemoryRebound(to: Int32.self, capacity: 8) { numsPtr in
                    memcpy(numsPtr, pv.baseAddress, 4 * v.count) // 4 = sizeof(Int32)
                }
            }

            // apply the function, that returns a heap-allocated C string
            let cString = title.withCString {
                sut.title = $0
                return cps_complex_accumulate_string(&sut)
            }
            guard let cString else {
                fatalError()
            }

            // convert the C string to a Swift string, remember to deallocate
            let string = String(cString: cString)
            cString.deallocate()
            return string
        }
        #expect(string == "Hello: 100")
    }

    // the internal struct lifetime is self-contained in C, only the
    // returned objects are managed by Swift
    @Test
    func opaqueStructs() {
        let v: [Int32] = [10, 20, 30, 40]
        let title = "Hello"
        let sut = v.withUnsafeBufferPointer { pv in
            title.withCString {
                cps_opaque_create(
                    $0,
                    pv.baseAddress,
                    pv.count,
                    cps_accumulate
                )
            }
        }
        guard let cString = cps_opaque_accumulate_string(sut) else {
            fatalError()
        }
        cps_opaque_destroy(sut)

        let string = String(cString: cString)
        cString.deallocate()
        #expect(string == "Hello: 100")
    }
}
