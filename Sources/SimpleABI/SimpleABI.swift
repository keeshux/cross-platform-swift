// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

import Foundation

enum SlowError: Int, Error {
    case foo = 10
    case bar = 20
    case unknown = 1000
}

func swiftSlowResult() async throws -> Int {
    100
}

@_cdecl("swift_slow_result")
public func swiftSlowResultWrapper(
    simulatingErrorCode: Int,
    ctx: UnsafeMutableRawPointer?,
    _ completion: @escaping @Sendable @convention(c) (UnsafeMutableRawPointer?, Int, Int) -> Void
) -> Void {
    nonisolated(unsafe) let unsafeCtx = ctx
    Task { @Sendable in
        do {
            if let simulatedError = SlowError(rawValue: simulatingErrorCode) {
                throw simulatedError
            }
            let result = try await swiftSlowResult()
            // Error code 0 means success
            completion(unsafeCtx, result, 0)
        } catch let error as SlowError {
            // The first argument must be ignored on failure
            completion(unsafeCtx, 0, error.rawValue)
        } catch {
            completion(unsafeCtx, 0, SlowError.unknown.rawValue)
        }
    }
}
