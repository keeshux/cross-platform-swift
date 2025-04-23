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

public final class CurrentValueStream<T>: @unchecked Sendable where T: Sendable {
    let queue = DispatchQueue(label: "CurrentValueStream")

    var observers: [UUID: AsyncStream<T>.Continuation] = [:]

    var throwingObservers: [UUID: AsyncThrowingStream<T, Error>.Continuation] = [:]

    var isFinished = false

    private var latestValue: T

    public init(_ initialValue: T) {
        latestValue = initialValue
    }

    deinit {
        observers.values.forEach {
            $0.finish()
        }
        throwingObservers.values.forEach {
            $0.finish()
        }
    }

    public func subscribe() -> AsyncStream<T> {
        let id = UUID() // best-effort, assume nonexistent observer id
        return AsyncStream { [weak self] continuation in
            guard let self else {
                return
            }
            queue.async {
                self.observers[id] = continuation
                continuation.yield(self.latestValue)
            }
            continuation.onTermination = { [weak self] _ in
                self?.queue.async { [weak self] in
                    self?.observers.removeValue(forKey: id)
                }
            }
        }
    }

    public func subscribeThrowing() -> AsyncThrowingStream<T, Error> {
        let id = UUID() // best-effort, assume nonexistent observer id
        return AsyncThrowingStream { [weak self] continuation in
            guard let self else {
                return
            }
            queue.async {
                self.throwingObservers[id] = continuation
                continuation.yield(self.latestValue)
            }
            continuation.onTermination = { [weak self] _ in
                self?.queue.async { [weak self] in
                    self?.throwingObservers.removeValue(forKey: id)
                }
            }
        }
    }

    public func send(_ value: T) {
        queue.async { [weak self] in
            guard let self, !isFinished else {
                return
            }
            latestValue = value
            for continuation in observers.values {
                continuation.yield(value)
            }
            for continuation in throwingObservers.values {
                continuation.yield(value)
            }
        }
    }

    public var value: T {
        queue.sync {
            latestValue
        }
    }
}

extension CurrentValueStream: SubjectStreamInternal {
}
