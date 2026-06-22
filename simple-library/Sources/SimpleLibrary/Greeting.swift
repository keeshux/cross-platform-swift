// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

public struct Greeting: Encodable, Sendable {
    public static let shared = Greeting(
        message: "Hello from Cross-platform Swift!"
    )
    let message: String

    public func json() -> String {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(self)
            guard let json = String(data: jsonData, encoding: .utf8) else {
                throw SimpleLibraryError()
            }
            return json
        } catch {
            return "Encoding failed"
        }
    }
}
