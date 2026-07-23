//
//  FoodDeliveryApp.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import SwiftUI
import SwiftData

@main
struct FoodDeliveryApp: App {
    let modelContainer: ModelContainer
    let diContainer: DIContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: FavoriteRecord.self)
        } catch {
            fatalError("Failed to initialize SwiftData ModelContainer: \(error)")
        }
        diContainer = DIContainer(modelContext: modelContainer.mainContext)
    }
    
    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
        
        WindowGroup {
            RootTabView(container: diContainer)
        }
        .modelContainer(modelContainer)
    }
}
