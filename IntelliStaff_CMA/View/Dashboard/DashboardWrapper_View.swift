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

    @State private var dashboardVM = DashboardViewModel()

    var body: some View {

            CurveConcavePreview(
                path: $path,
                dashboardViewModel: dashboardVM,
                division: division
            )
            
            .onAppear {
                if let contactID = division.contactID {
                    dashboardVM.fetchDashboard(contactID: contactID)
                }
            }
        
    }
}

#Preview {
    @Previewable @State var path: [AppRoute] = []
    DashboardWrapper_View(            division: DivisionList(
        clientName: "Acme Corp",
        clientID: 101,
        contactID: 202,
        divisionName: "Sales Division",
        pendingTS: 3,
        divisionId: 301,
        showLogin: 1,
        showBreakminutes: 0,
        name: "John Doe",
        master: 1,
        clientContactInfoId: 404
    ), path: $path)
}
