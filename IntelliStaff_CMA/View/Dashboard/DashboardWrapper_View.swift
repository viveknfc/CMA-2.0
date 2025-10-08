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

            CurveConcavePreview(
                path: $path,
                dashboardViewModel: dashboardVM, division: division
            )
        
            
            .onAppear {
                if let contactID = division.contactID, let clientid = division.clientID, let divisionID = division.divisionID{
                   
                    dashboardVM.fetchDashboard(contactID: contactID, clientID: clientid, divisionid: divisionID)
                    profileViewModel.fetchSubVendor(clientId: String(clientid), errorHandler: GlobalErrorHandler())
                    
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
        divisionID: 301,
        showLogin: 1,
        showBreakminutes: 0,
        name: "John Doe",
        master: 1,
        clientContactInfoID: 404
    ), path: $path)
}
