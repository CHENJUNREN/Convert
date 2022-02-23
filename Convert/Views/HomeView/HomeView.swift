//
//  HomeView.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var globalState: GlobalState
    @StateObject var viewModel = HomeViewModel()
    
    @FocusState var focusTextField: Bool
    @State var presentDocView = false
    @State var presentHistoryView = false
    
    var body: some View {
        NavigationView {
            mainScreen
                .blur(radius: globalState.isErrorPresented ? 5 : 0)
                .animation(.default, value: globalState.isErrorPresented)
                .overlay {
                    if globalState.isErrorPresented {
                        Color.black
                            .opacity(0.3)
                            .ignoresSafeArea()
                            .transition(.opacity.animation(.default))
                    }
                }
                .slideInMessage(isPresented: $globalState.isLoading, message: "功能加载中", autoDismiss: false) {
                    ProgressView()
                        .padding(.trailing, 1)
                }
                .bottomSheet(isPresented: $globalState.isErrorPresented) {
                    ErrorMessage()
                }
                .slideInMessage(isPresented: $globalState.showLoadingSuccess, message: "加载成功") {
                    Image(systemName: "checkmark.circle.fill")
                        .symbolRenderingMode(.multicolor)
                }
                .slideInMessage(isPresented: $globalState.showCopySuccess, message: "拷贝成功") {
                    Image(systemName: "checkmark.circle.fill")
                        .symbolRenderingMode(.multicolor)
                }
                .navigationTitle("")
                .navigationBarHidden(true)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .onTapGesture {
                    if focusTextField == true {
                        focusTextField = false
                    }
                }
                .sheet(isPresented: $presentDocView) {
                    SheetView {
                        DocView()
                    }
                }
                .sheet(isPresented: $presentHistoryView) {
                    SheetView {
                        HistoryView()
                    }
                }
        }
    }
    
    var mainScreen: some View {
        VStack(spacing: 0) {
            header
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    InputBox(focusTextField: $focusTextField, showHistoryView: $presentHistoryView)
                        .environmentObject(viewModel)
                        .padding(.bottom)
                        .frame(width: proxy.size.width, height: proxy.size.height / 10 * 5.5)
                    
                    DocBox(presentDocView: $presentDocView)
                        .frame(width: proxy.size.width, height: proxy.size.height / 10 * 4.5)
                }
            }
        }
        .padding()
    }
    
    var header: some View {
        HStack {
            Text("就是转换。")
                .font(.largeTitle.weight(.bold))
                .gradientForeground()
            
            Spacer()
            
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 25))
                    .symbolRenderingMode(.hierarchical)
                    .gradientForeground()
            }
        }
        .padding(.bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
