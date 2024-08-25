//
//  FairFareApp.swift
//  FairFare
//
//  Created by Daru Bagus Dananjaya on 25/08/24.
//

import SwiftUI

@main
struct FairFareApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
