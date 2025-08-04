//
//  Dashboard_Menu_Collection.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 20/07/25.
//

import SwiftUI

struct Dashboard_Menu_Collection: View {
    let assignments: [Dashboard_Menu_Items]

    @Binding var showToast: Bool
    @Binding var toastMessage: String
    @Binding var selectedAssignment: Dashboard_Menu_Items?
    @Binding var showSheet: Bool

    let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 3)

    var body: some View {
        ZStack {
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(assignments) { assignment in
                    Button {
                        if let children = assignment.children, !children.isEmpty {
                            withAnimation {
                                selectedAssignment = assignment
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                withAnimation {
                                    showSheet = true
                                }
                            }
                        } else {
                            toastMessage = "No sub-categories for this item"
                            if !showToast {
                                withAnimation {
                                    showToast = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation {
                                        showToast = false
                                    }
                                }
                            }
                        }
                    } label: {
                        Dashboard_Menu_Card(assignment: assignment)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 6)

        }
    }
}

#Preview {
    DashboardMenuCollectionPreviewWrapper()
}

struct DashboardMenuCollectionPreviewWrapper: View {
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var selectedAssignment: Dashboard_Menu_Items? = nil
    @State private var showSheet = false

    var body: some View {
        
        let sampleChildren = [
            ChildItem(name: "Algebra", apiKey: "link"),
            ChildItem(name: "Geometry", apiKey: "link"),
            ChildItem(name: "Trigonometry", apiKey: "link")
        ]

        let assignments: [Dashboard_Menu_Items] = [
            Dashboard_Menu_Items(id: 1, title: "Math", imageName: "book.closed", itemCount: 4, children: sampleChildren),
            Dashboard_Menu_Items(id: 2, title: "Science", imageName: "flask.fill", itemCount: 2, children: sampleChildren),
            Dashboard_Menu_Items(id: 3, title: "History", imageName: "clock", itemCount: 0, children: nil),
            Dashboard_Menu_Items(id: 4, title: "Art", imageName: "paintbrush", itemCount: 5, children: sampleChildren),
            Dashboard_Menu_Items(id: 5, title: "PE", imageName: "figure.walk", itemCount: 3, children: sampleChildren),
            Dashboard_Menu_Items(id: 6, title: "Music", imageName: "music.note", itemCount: 1, children: sampleChildren)
        ]
        
       return Dashboard_Menu_Collection(
            assignments: assignments,
            showToast: $showToast,
            toastMessage: $toastMessage,
            selectedAssignment: $selectedAssignment,
            showSheet: $showSheet
        )
    }
}



