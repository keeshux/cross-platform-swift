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

public enum SubjectStreamCompletion {
    case finished

    case failure(_ error: Error)
}

public protocol SubjectStream: AnyObject, Sendable {
    associatedtype T

    func send(_ value: T)

    func send(completion: SubjectStreamCompletion)

    func finish(throwing error: Error?)
}

protocol SubjectStreamInternal: SubjectStream {
    var queue: DispatchQueue { get }

    var observers: [UUID: AsyncStream<T>.Continuation] { get }

    var throwingObservers: [UUID: AsyncThrowingStream<T, Error>.Continuation] { get }

    var isFinished: Bool { get set }
}

extension SubjectStream {
    public func finish() {
        finish(throwing: nil)
    }
}

extension SubjectStream where T == Void {
    public func send() {
        send(())
    }
}

extension SubjectStreamInternal {
    public func send(completion: SubjectStreamCompletion) {
        switch completion {
        case .finished:
            finish()
        case .failure(let error):
            finish(throwing: error)
        }
    }

    public func finish(throwing error: Error?) {
        queue.async { [weak self] in
            guard let self, !isFinished else {
                return
            }
            isFinished = true
            for continuation in observers.values {
                continuation.finish()
            }
            for continuation in throwingObservers.values {
                if let error {
                    continuation.finish(throwing: error)
                    continue
                }
                continuation.finish()
            }
        }
    }
}
