//
//  BottomView.swift
//  IntelliStaff_CMA
//
//  Created by ios on 11/09/25.
//

import Foundation
import SwiftUI

struct BottomNavigationBar: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Home indicator
            
            HStack(spacing: 0) {
                // Home
                BottomNavItem(
                    icon: "house.fill",
                    isSelected: selectedTab == 0
                ) {
                    selectedTab = 0
                }
                
                // Documents
                BottomNavItem(
                    icon: "doc.text",
                    isSelected: selectedTab == 1
                ) {
                    selectedTab = 1
                }
                
                // Add (Center button)
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.4, green: 0.45, blue: 0.85))
                            .frame(width: 56, height: 56)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .offset(y: -8)
                
                // Timer with badge
                BottomNavItem(
                    icon: "timer",
                    isSelected: selectedTab == 2,
                    hasBadge: true
                ) {
                    selectedTab = 2
                }
                
                // Profile
                BottomNavItem(
                    icon: "person",
                    isSelected: selectedTab == 3
                ) {
                    selectedTab = 3
                }
                
                
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(.white)
        }
        .background(.white)
        
        Capsule()
            .fill(.black)
            .frame(width: 134, height: 5)
            .padding(.bottom, 8)
    }
}

struct BottomNavItem: View {
    let icon: String
    let isSelected: Bool
    let hasBadge: Bool
    let action: () -> Void
    
    init(icon: String, isSelected: Bool, hasBadge: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.isSelected = isSelected
        self.hasBadge = hasBadge
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? Color(red: 0.4, green: 0.45, blue: 0.85) : .gray)
                
                if hasBadge {
                    Circle()
                        .fill(.red)
                        .frame(width: 8, height: 8)
                        .offset(x: 12, y: -12)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
#Preview("With App Header") {
    BottomNavigationBar()
}
