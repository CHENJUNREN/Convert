//
//  QueryModeView.swift
//  Convert
//
//  Created by Chenjun Ren on 2021-12-24.
//

import SwiftUI

struct QueryModeView: View {
    
    @FocusState var focusTextField: Bool
    @State var presentDocView = false
    @State var selectedConversionType: ConversionType = .currency
    @State var showDocViewNotice = true
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                InputBox(focusTextField: $focusTextField)
                    .padding(.bottom)
                    .frame(width: proxy.size.width, height: proxy.size.height / 10 * 5.5)
                
                DocBox(presentDocView: $presentDocView)
                    .frame(width: proxy.size.width, height: proxy.size.height / 10 * 4.5)
            }
        }
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

struct QueryModeView_Previews: PreviewProvider {
    static var previews: some View {
        QueryModeView()
    }
}
