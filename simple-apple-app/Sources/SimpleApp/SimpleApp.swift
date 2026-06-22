// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

import SwiftUI

@main
struct SimpleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: doShow)
        }
    }

    private func doShow() {
        // Force NSApplication to exist and tweak it
        // NSApp is guaranteed non-nil here
        guard let app = NSApp else { fatalError() }
        print("NSApp:", app)

        // Example: remove the title from the app menu
        if let mainMenu = app.mainMenu {
            mainMenu.items.first?.title = "SimpleApp"
        }

        // Example: change activation policy (optional)
        app.setActivationPolicy(.regular)

        // Bring app to front immediately
        app.activate(ignoringOtherApps: true)
    }
}
