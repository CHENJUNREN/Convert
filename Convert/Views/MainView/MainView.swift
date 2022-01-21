//
//  MainView.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-24.
//

import SwiftUI

struct MainView: View {
    
    @FocusState var focusTextField: Bool
    @State var presentDocView = false
    @State var selectedConversionType: ConversionType = .currency
    @State var showDocViewNotice = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Header()
                
                VStack(spacing: 15) {
                    GeometryReader { geo in
                        InputBox(focusTextField: $focusTextField, geo: geo)
                    }
                        
                    GeometryReader { geometry in
                        DocBox(presentDocView: $presentDocView, geo: geometry)
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
            .fullScreenCover(isPresented: $presentDocView) {
                DocView(selectedConversionType: $selectedConversionType, showNotice: $showDocViewNotice)
            }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
