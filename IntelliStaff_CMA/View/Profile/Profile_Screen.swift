//
//  Profile_Screen.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 12/08/25.
//

import SwiftUI

struct Profile_Screen: View {
    
    @State var viewModal: ProfileList_VM
    @Binding var showLogoutAlert: Bool
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModal.profileList) { item in
                            Button(action: {
                                
                                print("row clicked: \(item.title)")
                                
                                if item.title == "Logout" {
                                    showLogoutAlert = true
                                }
                                
                            }) {
                                Profile_Row(item: item)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 0)
                }
                .onAppear {
                    viewModal.fetchProfileList()
                }
            }
        }
        
    }
}

#Preview {
    var vm = ProfileList_VM()
    vm.fetchProfileList() // so preview has sample rows
    return Profile_Screen(
        viewModal: vm,
        showLogoutAlert: .constant(false)
    )
}
