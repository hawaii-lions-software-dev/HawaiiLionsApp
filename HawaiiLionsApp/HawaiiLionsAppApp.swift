//
//  HawaiiLionsAppApp.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 7/3/22.
//

import SwiftUI

@main
struct HawaiiLionsAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
