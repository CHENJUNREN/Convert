//
//  MainView.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewModel: MasterViewModel
    
    @FocusState var focusTextField: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Header()
                
                VStack(spacing: 15) {
                    GeometryReader { geo in
                        InputBox(focusTextField: $focusTextField, geo: geo)
                    }
                        
                    GeometryReader { geometry in
                        DocBox(geo: geometry)
                    }
                }
            }
            .padding(.horizontal)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationBarHidden(true)
            .navigationTitle("就是转换。")
            .onTapGesture {
                if focusTextField == true {
                    focusTextField = false
                }
            }
        }
        .task {
            await viewModel.fetchAllConversionUnits()
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct Header: View {
    @State var gradientValue = 0.0
    
    var body: some View {
        HStack {
//            Text("Convert.")
//                .font(.custom("Menlo", size: 48, relativeTo: .largeTitle))
//                .fontWeight(.ultraLight)
            Text("就是转换。")
                .font(.largeTitle.bold())
                .animatableGradientForeground(fromGradient: Gradient(colors: [.pink, .accentColor]),
                                              toGradient: Gradient(colors: [.red, .indigo]),
                                              percentage: gradientValue)
                .animation(.linear(duration: 5.0).delay(5.0).repeatForever(autoreverses: true), value: gradientValue)
            
            Spacer()
            
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
            }
        }
        .padding(.vertical, 10)
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            gradientValue = 1.0
        }
    }
}
