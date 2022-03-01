//
//  ConvertApp.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-24.
//

import SwiftUI

@main
struct ConvertApp: App {
    @StateObject var globalState = GlobalState()
    
    @AppStorage("colorScheme") var selectedColorScheme = ColorScheme.unspecified
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(
                    selectedColorScheme == .light ? .light :
                        selectedColorScheme == .dark ? .dark : nil
                )
                .environmentObject(globalState)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .onAppear {
                    // This suppresses contraint warnings
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
