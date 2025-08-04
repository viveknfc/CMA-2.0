//
//  DashboardWrapper_View.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 04/08/25.
//

import SwiftUI

struct DashboardWrapper_View: View {
    let contactID: Int
    @Binding var path: [AppRoute]

    @State private var dashboardVM = DashboardViewModel()

    var body: some View {

            CurveConcavePreview(
                path: $path,
                dashboardViewModel: dashboardVM
            )
            
            .onAppear {
                dashboardVM.fetchDashboard(contactID: contactID)
            }
        
    }
}

#Preview {
    @Previewable @State var path: [AppRoute] = []
    DashboardWrapper_View(contactID: 123, path: $path)
}
