//
//  NnttawyeApp.swift
//  Nnttawye
//
//  Created by Yizhou Li on 12/21/21.
//
                        
import SwiftUI

@main
struct NnttawyeApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var recordModel = RecordModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(recordModel)
        }
    }
}
