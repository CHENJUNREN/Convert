//
//  More.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/8.
//

import SwiftUI

struct More: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Group {
                VStack(alignment: .center, spacing: 15) {
                    Image("avatar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .background {
                            Circle()
                                .stroke(lineWidth: 2)
                                .frame(width: 85, height: 85)
                                .opacity(0.1)
                        }
                    
                    Text("Chenjun Ren")
                        .font(.title3.monospaced().weight(.semibold))
                        .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 2.5) {
                        Text("一个碌碌无为的普通人。")
                        Text("如果这个软件对您有帮助，请考虑支持一下😄")
                    }
                    .foregroundColor(.secondary)
                    .font(.footnote)
                    
                    HStack(spacing: 20) {
                        Button {
                            
                        } label: {
                            Image(systemName: "envelope.circle.fill")
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "square.and.arrow.up.circle.fill")
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "hand.thumbsup.circle.fill")
                                
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "yensign.circle.fill")
                        }
                    }
                    .font(.title)
                    .foregroundColor(.primary)
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 5, y: 5)
                .shadow(color: .black.opacity(0.1), radius: 10, x: -5, y: -5)
                .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Label("技术支持", systemImage: "gear.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.headline)
                            .padding(.bottom, 5)
                        Spacer()
                    }
                    Text("货币转换数据由 **exchangerate.host** 提供")
                    Text("Special thanks to **exchangerate.host** for providing the currency conversion data")
                        .foregroundColor(.secondary)
                    Text("[https://exchangerate.host/](https://exchangerate.host/)")
                }
                .font(.footnote)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 5, y: 5)
                .shadow(color: .black.opacity(0.1), radius: 10, x: -5, y: -5)
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.headline)
                        
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    
                    Text("特别感谢 **朱彬旖** 这几年来对我的帮助，间接促使我完成了这一款对我来说真正意义上的独立开发软件，感谢🙏")
                }
                .font(.subheadline)
                .padding()
                .foregroundColor(.white)
                .background {
                    LinearGradient(colors: [.orange, .red, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                }
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 5, y: 5)
                .shadow(color: .black.opacity(0.1), radius: 10, x: -5, y: -5)
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
    }
}

struct More_Previews: PreviewProvider {
    static var previews: some View {
        More()
    }
}
