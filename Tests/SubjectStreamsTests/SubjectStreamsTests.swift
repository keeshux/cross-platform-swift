// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

import Foundation
import SubjectStreams
import XCTest

final class SubjectStreamTests: XCTestCase {
    func test_givenPassthrough_whenEmit_thenMatches() async throws {
        let sut = PassthroughStream<Int>()
        let expected = [5, 7, 67]
        nonisolated(unsafe) var isReady = false
        let task = Task { @Sendable in
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
        nonisolated(unsafe) var isReady = false
        let task = Task { @Sendable in
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
