//
//  Profile_Screen.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 12/08/25.
//

import SwiftUI

struct Profile_Screen: View {
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    @State var viewModal: ProfileList_VM
    var clientID:Int
    var contactID:Int
    @Binding var showLogoutAlert: Bool
    @Binding var path: [AppRoute]
    @State var viewModel = DivisionList_VM()
    @State private var dashboardVM = DashboardViewModel()
    

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(viewModal.profileList) { item in
                            Button {
                                handleItemTap(item: item)
                            } label: {
                                Profile_Row(item: item)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle()) // whole row tappable
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 0)
                }
                if viewModel.isLoading {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()

                    TriangleLoader()
                }
            }
            
            
            .onAppear {
                viewModal.fetchSubVendor(clientId: "\(clientID)", errorHandler: errorHandler)
                viewModal.getMenuItems()
            }
        }
    }

    private func handleItemTap(item: ProfileModel) {
        print("row clicked: \(item.title)")
        
        switch item.title {
        case "Edit Your Information":
            path.append(.webView(apiKey: "EditYourInformation"))
           // break
        case "Verify Billing Information":
            path.append(.webView(apiKey: "VerifyBillingInformation"))
          //  break
        case "Your Client Rep":
            path.append(.clientRep(clientId: clientID, contactId: contactID))
           // path.append(.webView(apiKey: "Cwa2dev/VerifyBillingInformation"))
        case "Change Password":
            let userName = UserDefaults.standard.string(forKey: "Username") ?? ""
            path.append(.newPassword(email: userName))
        case "Logout":
            showLogoutAlert = true
        default:
            break
        }
    }
}

#Preview {
    // Mock environment object
    let errorHandler = GlobalErrorHandler()
    
    // Mock view model
    let vm = ProfileList_VM()
    vm.profileList = [
        ProfileModel(title: "Edit Your Information", imageName: "pencil"),
        ProfileModel(title: "Verify Billing Information", imageName: "creditcard"),
        ProfileModel(title: "Your Client Rep", imageName: "person.crop.circle"),
        ProfileModel(title: "Change Password", imageName: "lock"),
        ProfileModel(title: "Logout", imageName: "arrow.right.square")
    ]
    
   return Profile_Screen(
        viewModal: vm,
        clientID: 12345,
        contactID: 0000,
        showLogoutAlert: .constant(false),
        path: .constant([])
    )
    .environmentObject(errorHandler)
}
