//
//  ContentView.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/1.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(wrappedValue: 0, "preferredMode") var preferredMode
    @StateObject var queryModelViewModel = QueryModeViewModel()
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    Header()
                    
                    if preferredMode == 0 {
                        QueryModeView()
                            .environmentObject(queryModelViewModel)
                    } else if preferredMode == 1 {
                        ListModeView()
                    } else {
                        SelectorModeView()
                    }
                }
                .padding()
                .blur(radius: globalState.isInitializing ? 5 : 0)
                .animation(.easeInOut(duration: 0.75), value: globalState.isInitializing)
                .navigationTitle("就是转换。")
                .navigationBarHidden(true)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .zIndex(0)
                
                if globalState.isInitializing {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .transition(.opacity.animation(.easeInOut(duration: 0.75)))
                        .zIndex(1)
                }
                
                if globalState.isLoading && !globalState.isErrorPresented {
                    ProgressView("功能加载中")
                        .frame(width: 120, height: 120)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .transition(.scale.combined(with: .opacity).animation(.easeInOut(duration: 0.5)))
                        .zIndex(2)
                }
                
                ErrorMessage()
                    .zIndex(3)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
