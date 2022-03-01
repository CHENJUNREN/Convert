//
//  TagList.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/1/27.
//

import SwiftUI

struct TagList: View {
    @Binding var selectedConversionType: ConversionType
    @Namespace var animation
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(ConversionType.allCases, id: \.self) { type in
                        VStack(spacing: 5) {
                            Text(type.rawValue)
                                .id(type)
                                .font(.footnote)
                                .foregroundColor(selectedConversionType == type ? .primary : .secondary)
                                .padding(.horizontal, 5)
                            
                            if selectedConversionType == type {
                                Capsule()
                                    .fill(.primary)
                                    .frame(height: 3)
                                    .matchedGeometryEffect(id: "capsule", in: animation)
                            } else {
                                Capsule()
                                    .fill(.clear)
                                    .frame(height: 3)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedConversionType = type
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .overlay(
                Divider().offset(x: 0, y: -1.5),
                     alignment: .bottom)
            .onChange(of: selectedConversionType) { newValue in
                withAnimation(.easeInOut) {
                    proxy.scrollTo(newValue, anchor: .topTrailing)
                }
            }
        }
        
    }
}
