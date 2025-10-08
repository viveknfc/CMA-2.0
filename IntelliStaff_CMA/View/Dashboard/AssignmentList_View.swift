//
//  AssignmentList_View.swift
//  IntelliStaff_CMA
//
//  Created by ios on 01/10/25.
//

import SwiftUI

struct AssignmentList_View: View {

    var assignmentData: AssignmentResponse?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            let assignmentDataItems = assignmentData?.candateAssignmentsDetailsList ?? []
            
            Text("Assignments today(\(assignmentDataItems.count))")
                .font(.bodyFont)
                .foregroundColor(.black)
            
            if assignmentData?.totalRows == 0 {
                Text("No assignments available")
                    .foregroundColor(.gray)
                    .font(.menuFont)
                    .padding(.top, 8)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(assignmentDataItems, id: \.orderID) { item in
                            HStack(spacing: 8) {
                                Image(systemName: "suitcase.fill") // SF Symbol for a bag
                                    .foregroundColor(.theme)
                                    .font(.body) // Adjust size if needed
                                Text(item.position)
                                    .foregroundColor(.gray)
                                    .font(.bodyFont)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    AssignmentPreviewWrapper()
}

struct AssignmentPreviewWrapper: View {
    @State var assignmentData: AssignmentResponse? = nil
    
    var body: some View {
        return AssignmentList_View(assignmentData: assignmentData)
    }
}
