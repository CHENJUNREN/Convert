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
    @StateObject var viewModel = MasterViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(preferredAppearance == 1 ? .light : preferredAppearance == 2 ? .dark : nil)
                .environmentObject(viewModel)
        }
    }
}
