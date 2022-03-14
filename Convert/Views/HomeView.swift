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
    @State var presentHistoryView = false
    @State var presentCalculatorView = false
    @State var presentSettingsView = false
    
    @State var presentUseManualView = false
    @State var selectedDoc = DocType.reminder
    @State var selectedConversionType = ConversionType.currency
        
    var body: some View {
        NavigationView {
            mainScreen
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
                .navigationTitle("")
                .navigationBarHidden(true)
        }
        .sheet(isPresented: $presentUseManualView) {
            SheetView {
                UseManualView(selectedDoc: $selectedDoc, selectedConversionType: $selectedConversionType)
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
                .padding(.bottom)
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    InputBox(focusTextField: $focusTextField)
                        .environmentObject(viewModel)
                        .padding(.bottom)
                        .frame(width: proxy.size.width, height: proxy.size.height / 10 * 5.5)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                keyboardToolbarItems
                            }
                        }
                    
                    docBox
                        .frame(width: proxy.size.width, height: proxy.size.height / 10 * 4.5)
                }
            }
        }
        .padding()
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture {
            if focusTextField == true {
                focusTextField = false
            }
        }
        .gesture(swipeGesture)
    }
    
    var header: some View {
        HStack {
            Text("就是转换。")
                .font(.largeTitle.weight(.bold))
                .gradientForeground()
            
            Spacer()
            
            NavigationLink(isActive: $presentSettingsView) {
                SettingsView()
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.system(size: 25))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var docBox: some View {
        VStack(spacing: 20) {
            Label("使用指南", systemImage: "doc.text.magnifyingglass")
                .font(.title.weight(.semibold))
                .gradientForeground()
            
            VStack(spacing: 5) {
                Text("输入格式:")
                    .font(.title3)
                Text("值 + 空格 + 单位 + 空格 + 转换单位")
                    .font(.headline)
                Text("例如, \"100 usd cny\"")
                    .font(.callout)
            }
            .foregroundColor(.secondary)
            
            Button("查看更多") {
                selectedDoc = .reminder
                presentUseManualView = true
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clippedToRoundedRectangle(background: Color(uiColor: .secondarySystemBackground))
    }
    
    var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 100, coordinateSpace: .local)
            .onEnded { value in
                let horizontalAmount = value.translation.width
                let verticalAmount = value.translation.height
                if abs(verticalAmount) > abs(horizontalAmount) {
                    if verticalAmount > 0 {
                        // swipe down
                        if focusTextField == true {
                            focusTextField = false
                        }
                    } else {
                        // swipe up
                        presentHistoryView = true
                    }
                } else {
                    if horizontalAmount < 0 {
                        // swipe left
                        presentSettingsView = true
                    }
                }
            }
    }
    
    var keyboardToolbarItems: some View {
        HStack(alignment: .center) {
            Spacer()
            
            Button {
                selectedDoc = .cheatsheet
                presentUseManualView = true
            } label: {
                Image(systemName: "doc.text.magnifyingglass")
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Button {
                presentHistoryView = true
            } label: {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    presentCalculatorView = true
                }
                focusTextField = false
            } label: {
                Image(systemName: "plus.forwardslash.minus")
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Button {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                viewModel.textFieldInput = ""
            } label: {
                Image(systemName: "trash.fill")
                    .foregroundColor(viewModel.textFieldInput.isEmpty ? .secondary : .red)
            }
            .disabled(viewModel.textFieldInput.isEmpty)
            
            Spacer()
        }
        .font(.callout)
    }
}
