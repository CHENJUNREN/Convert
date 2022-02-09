//
//  ErrorMessage.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/2.
//

import SwiftUI

struct ErrorMessage: View {
    
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        let types = globalState.servicesError.keys.map { $0 }
        
        BottomSheet(isPresented: $globalState.isErrorPresented) {
            VStack(spacing: 0) {
                if globalState.isConnectedToNetwork {
                    Image(systemName: "xmark.square.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 100))
                        .padding(.bottom, 20)
                } else {
                    Image(systemName: "wifi.exclamationmark")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.yellow, .secondary)
                        .font(.system(size: 100))
                        .padding(.bottom, 20)
                }
                
                VStack(spacing: 10) {
                    HStack {
                        ForEach(types.indices, id: \.self) { index in
                            Text("\(types[index].rawValue)")
                                .fontWeight(.semibold)
                        }
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
                        Task {
                            await globalState.reloadServices()
                        }
                    }
                } label: {
                    HStack {
                        if globalState.isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                        
                        Text("重新加载")
                    }
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
                .padding(.top, 30)
                .animation(.spring(), value: globalState.isLoading)
            }
            .padding(40)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .animation(.spring(), value: globalState.isConnectedToNetwork)
        } dismiss: {
            if !globalState.isLoading {
                globalState.isInitializing = false
            }
        }

    }
}

struct ErrorMessage_Previews: PreviewProvider {
    static var previews: some View {
        ErrorMessage()
            .preferredColorScheme(.dark)
    }
}
