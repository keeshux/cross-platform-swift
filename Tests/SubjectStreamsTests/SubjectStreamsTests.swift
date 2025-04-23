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

import Foundation
import SubjectStreams
import XCTest

final class SubjectStreamTests: XCTestCase {
    func test_givenPassthrough_whenEmit_thenMatches() async throws {
        let sut = PassthroughStream<Int>()
        let expected = [5, 7, 67]
        var isReady = false
        let task = Task {
            let stream = sut.subscribe()
            isReady = true
            var i = 0
            for try await num in stream {
                print("Number: \(num)")
                guard i < expected.count else {
                    XCTFail("Emitted more values than sequence length")
                    return
                }
                XCTAssertEqual(num, expected[i])
                i += 1
            }
        }
        while !isReady {} // spinlock
        for num in expected {
            sut.send(num)
            try await Task.sleep(for: .milliseconds(100))
        }
        sut.finish()
        try await task.value
    }

    func test_givenCurrentValue_whenEmit_thenMatches() async throws {
        let sut = CurrentValueStream<Int>(100)
        let sequence = [5, 7, 67]
        let expected = [100] + sequence
        var isReady = false
        let task = Task {
            let stream = sut.subscribe()
            isReady = true
            var i = 0
            for try await num in stream {
                print("Number: \(num)")
                guard i < expected.count else {
                    XCTFail("Emitted more values than sequence length")
                    return
                }
                XCTAssertEqual(num, expected[i])
                i += 1
            }
        }
        while !isReady {} // spinlock
        for num in sequence {
            sut.send(num)
            try await Task.sleep(for: .milliseconds(100))
        }
        sut.finish()
        try await task.value
    }
}
