//
//  DashboardWrapper_View.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 04/08/25.
//

import SwiftUI

struct DashboardWrapper_View: View {
    let division: DivisionList
    @Binding var path: [AppRoute]
    var profileViewModel = ProfileList_VM()
    var divViewModel = DivisionList_VM()
    @State private var dashboardVM = DashboardViewModel()

    var body: some View {
        ZStack {
            // MARK: - Main Dashboard View
            CurveConcavePreview(
                path: $path,
                dashboardViewModel: dashboardVM,
                division: division
            )

            .onAppear {
                if dashboardVM.dashboardMenuItems.isEmpty,  // ✅ only fetch if empty
                   let contactID = division.contactID,
                   let clientID = division.clientID,
                   let divisionID = division.divisionID, let clientName = division.clientName, profileViewModel.profileList.isEmpty {
                    dashboardVM.fetchDashboard(contactID: contactID, clientID: clientID, divisionid: divisionID, clientName: clientName)
                    profileViewModel.fetchSubVendor(
                    clientId: String(clientID),
                    errorHandler: GlobalErrorHandler())
                }
            }


            // MARK: - Loader Overlay
            if dashboardVM.isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                TriangleLoader()
            }
        }
    }
}

#Preview {
    @Previewable @State var path: [AppRoute] = []
    DashboardWrapper_View(
        division: DivisionList(
            clientName: "Test - Office of Asylum Seeker Operations",
            clientID: 101,
            contactID: 202,
            divisionName: "Sales Division",
            pendingTS: 3,
            divisionID: 301,
            showLogin: 1,
            showBreakminutes: 0,
            name: "John Doe",
            master: 1,
            clientContactInfoID: 404
        ),
        path: $path
    )
}

