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
    @State var presentCalculatorView = false
    
    var body: some View {
        NavigationView {
            mainScreen
                .navigationTitle("")
                .navigationBarHidden(true)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .onTapGesture {
                    if focusTextField == true {
                        focusTextField = false
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        keyboardToolbarItems
                    }
                }
                .blur(radius: globalState.isErrorPresented ? 5 : 0)
                .animation(.default, value: globalState.isErrorPresented)
                .overlay {
                    if globalState.isErrorPresented || presentCalculatorView {
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
                .slideInMessage(isPresented: $globalState.showLoadingSuccess, message: "加载成功") {
                    Image(systemName: "checkmark.circle.fill")
                        .symbolRenderingMode(.multicolor)
                }
                .slideInMessage(isPresented: $globalState.showCopySuccess, message: "拷贝成功") {
                    Image(systemName: "checkmark.circle.fill")
                        .symbolRenderingMode(.multicolor)
                }
                .bottomSheet(isPresented: $globalState.isErrorPresented) {
                    ErrorMessage()
                }
                .bottomSheet(isPresented: $presentCalculatorView, showDismissButton: false) {
                    CalculatorView(textFieldInput: $viewModel.textFieldInput, isPresented: $presentCalculatorView, focusTextField: $focusTextField)
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
    
    var mainScreen: some View {
        VStack(spacing: 0) {
            header
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    InputBox(focusTextField: $focusTextField)
                        .environmentObject(viewModel)
                        .padding(.bottom)
                        .frame(width: proxy.size.width, height: proxy.size.height / 10 * 5.5)
                    
                    docBox
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
    
    var docBox: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                Label("使用指南", systemImage: "doc.text.magnifyingglass")
                    .font(.title.weight(.semibold))
                    .gradientForeground()
                
                VStack(spacing: 5) {
                    Text("查询格式:")
                        .font(.title3)
                    Text("值 + 空格 + 单位 + 空格 + 转换单位")
                        .font(.headline)
                    Text("例如, \"100 usd cny\"")
                        .font(.callout)
                }
                .foregroundColor(.secondary)
                
                Button("查看更多") {
                    presentDocView = true
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(15)
        }
    }
    
    var keyboardToolbarItems: some View {
        HStack {
            Spacer()
            
            Button {
                presentHistoryView = true
            } label: {
                Label("转换记录", systemImage: "clock")
                    .symbolRenderingMode(.multicolor)
                    .foregroundColor(.primary)
                    .labelStyle(.titleAndIcon)
            }
            
            Divider()
            
            Button {
                focusTextField = false
                withAnimation {
                    presentCalculatorView = true
                }
            } label: {
                Label("计算器", systemImage: "candybarphone")
                    .foregroundColor(.primary)
                    .labelStyle(.titleAndIcon)
            }
        }
    }
}
