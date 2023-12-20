//
//  Bootcamp_CoreDataApp.swift
//  Bootcamp-CoreData
//
//  Created by lorenliang on 2023/12/20.
//

import SwiftUI

@main
struct Bootcamp_CoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
