//
//  Tab_SupportItem.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 24/07/25.
//

import SwiftUI

struct ControlView<Content: View>: View {
   
   @Binding var selection: Int
   @Binding var constant: ATConstant
   @Binding var radius: CGFloat
   @Binding var concaveDepth: CGFloat
   @Binding var color: Color
   
    let tag: Int
    let systemName: String
    let safeArea: EdgeInsets
    let content: () -> Content
   
   var body: some View {
       ZStack {
           Rectangle()
               .fill(.white)
           if selection == tag {
               
               if tag == 0 {
                   Color.gray.opacity(0.1).ignoresSafeArea()
               } else {
                   Color.white.ignoresSafeArea()
               }
               
                   content()
                       .padding()
                       .padding(.top, getTopPadding())
                       .padding(.bottom, getBottomPadding())
           }
       }
       .tabItem(tag: tag, normal: {
           TabButton(constant: $constant, selection: $selection, tag: tag, isSelection: false, systemName: systemName)
       }, select: {
           TabButton(constant: $constant, selection: $selection, tag: tag, isSelection: true, systemName: systemName)
       })
   }
   
   private func getTopPadding() -> CGFloat {
       guard !constant.screen.activeSafeArea else { return 0 }
       return constant.axisMode == .top ? constant.tab.normalSize.height + safeArea.top : 0
   }
   
   private func getBottomPadding() -> CGFloat {
       guard !constant.screen.activeSafeArea else { return 0 }
       return constant.axisMode == .bottom ? constant.tab.normalSize.height + safeArea.bottom : 0
   }
}

struct TabButton: View {
   
   @Binding var constant: ATConstant
   @Binding var selection: Int
   
   let tag: Int
   let isSelection: Bool
   let systemName: String
   
   @State private var y: CGFloat = 0
   
   var content: some View {
       ZStack {
            Image(systemName: systemName)
               .resizable()
               .frame(width: 24, height: 24) //26
               .padding(14)//20
               .foregroundColor(isSelection ? .white : .white)
               .background(
                   Circle()
                    .fill(isSelection ? .theme : .clear)
                       .shadow(color: isSelection ? .red.opacity(0.3) : .clear, radius: isSelection ? 10 : 0, x: 0, y: 4)
               )
               .scaleEffect(isSelection ? 1.2 : 1.0)
               .animation(.easeInOut(duration: 0.25), value: isSelection)
       }
       .frame(width: 50, height: 50)
       .offset(y: isSelection ? y : 8)
       .onAppear {
           updateOffset()
       }
       .onChange(of: isSelection) {
           updateOffset()
       }
   }
   
   private func updateOffset() {
       if isSelection {
           withAnimation(.easeInOut(duration: 0.26)) {
               y = constant.axisMode == .top ? 14 : -14 //22
           }
           withAnimation(.easeInOut(duration: 0.3).delay(0.25)) {
               y = constant.axisMode == .top ? 12 : -12 //17
           }
       } else {
           y = 0
       }
   }

   var body: some View {
       content
   }
}
