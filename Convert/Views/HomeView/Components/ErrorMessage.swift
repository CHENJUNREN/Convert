//
//  ErrorMessage.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/2.
//

import SwiftUI

struct ErrorMessage: View {
    @EnvironmentObject var globalState: GlobalState
    
    @State var invalidAttempts = 0
    
    var body: some View {
        let types: String = String(globalState.servicesError.keys
            .map { $0 }
            .reduce("") { partialResult, type in
                partialResult + type.rawValue + "，"
            }
            .dropLast(1))
        
        VStack(spacing: 0) {
            Image(systemName: "wifi.exclamationmark")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.yellow, .secondary)
                .font(.system(size: 100))
                .padding(.bottom, 20)
            
            VStack(spacing: 10) {
                HStack(spacing: 0) {
                    Text(types)
                        .font(.headline)
                    Text("转换功能无法使用")
                }
                
                if globalState.isConnectedToNetwork {
                    Text("请尝试重新加载")
                        .font(.headline)
                } else {
                    Text("请连接网络后，再尝试重新加载")
                        .font(.headline)
                }
            }
                
            Button {
                if !globalState.isLoading {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                    Task {
                        await globalState.initServices()
                        // button shakes when loading failed
                        if globalState.isErrorPresented {
                            invalidAttempts += 1
                        }
                    }
                }
            } label: {
                Label("重新加载", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .padding(.top, 30)
            .modifier(ShakeEffect(shakes: invalidAttempts * 2))
            .animation(.default, value: invalidAttempts)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .animation(.default, value: globalState.isConnectedToNetwork)
    }
}
