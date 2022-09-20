//
//  ThingsToDoApp.swift
//  ThingsToDo
//
//  Created by Kosei Ban on 2022-09-16.
//

import SwiftUI

@main
struct ThingsToDoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
