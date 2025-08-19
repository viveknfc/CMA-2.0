//
//  Top_TabView.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 13/08/25.
//

import SwiftUI

struct Top_TabView: View {
    
    enum Tab: String, CaseIterable, Identifiable {
        case first = "Check In"
        case second = "Check Out"
        case third = "Break Minutes"
        case fourth = "Overall"
        
        var id: String { self.rawValue }
    }
    
    @State private var selectedTab: Tab = .first
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Tab Bar
            HStack(spacing: 0) {
                ForEach(Tab.allCases) { tab in
                    Button(action: {
                        withAnimation {
                            selectedTab = tab
                        }
                    }) {
                        Text(tab.rawValue)
                            .font(.buttonFont)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(selectedTab == tab ? Color.blue.opacity(0.2) : Color.clear)
                            .foregroundColor(selectedTab == tab ? .theme : .gray)
                    }
                }
            }
            .background(Color(UIColor.systemGray6)) // Background color of the tab bar
            .overlay(
                // Active tab underline
                GeometryReader { geometry in
                    let tabWidth = geometry.size.width / CGFloat(Tab.allCases.count)
                    Rectangle()
                        .fill(.theme)
                        .frame(width: tabWidth, height: 2)
                        .offset(x: tabOffset(in: geometry.size.width))
                        .animation(.easeInOut(duration: 0.3), value: selectedTab)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            )
            
            Divider()
            
            // Tab Content
            ZStack {
                switch selectedTab {
                case .first:
                    Check_In()
                    
                case .second:
                    Check_Out()
                    
                case .third:
                    Break_Min()
                    
                case .fourth:
                   // Text("Fourth Tab Content")
                    ECheckin_View(
                        path: .constant([]))
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // Helper for underline offset
    private func tabOffset(in totalWidth: CGFloat) -> CGFloat {
        let index = Tab.allCases.firstIndex(of: selectedTab) ?? 0
        let tabWidth = totalWidth / CGFloat(Tab.allCases.count)
        return CGFloat(index) * tabWidth
    }
    
}

#Preview {
    Top_TabView()
}
