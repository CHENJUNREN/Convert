//
//  ConvertApp.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-24.
//

import SwiftUI

@main
struct ConvertApp: App {
    @AppStorage(wrappedValue: 0, "preferredAppearance") var preferredAppearance
    @StateObject var globalState = GlobalState()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(preferredAppearance == 1 ? .light : preferredAppearance == 2 ? .dark : nil)
                .environmentObject(globalState)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .onAppear {
                    // This suppresses contraint warnings
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
