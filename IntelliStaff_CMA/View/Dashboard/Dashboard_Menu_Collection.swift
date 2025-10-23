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
    @Binding var path: [AppRoute]

    let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 3)

    var body: some View {
        ZStack {
            
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(assignments) { assignment in
                    Button {
                        if assignment.title == "Site" {
                            // ✅ Navigate back to previous screen
                            if !path.isEmpty {
                                path.append(.divisionList)
                                print("✅ Navigated back, path count: \(path.count)")
                            } else {
                                print("⚠️ Path is already empty, cannot navigate back")
                            }
                        }
                        else if let children = assignment.children, !children.isEmpty {
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
    @State private var path: [AppRoute] = [.divisionList] // simulate navigation stack

    var body: some View {
        let sampleChildren = [
            ChildItem(name: "Algebra", imageName: "banknote", apiKey: "link"),
            ChildItem(name: "Geometry", imageName: "banknote", apiKey: "link"),
            ChildItem(name: "Trigonometry", imageName: "banknote", apiKey: "link")
        ]

        let assignments: [Dashboard_Menu_Items] = [
            Dashboard_Menu_Items(title: "Math", imageName: "book.closed", itemCount: 4, children: sampleChildren),
            Dashboard_Menu_Items(title: "Science", imageName: "flask.fill", itemCount: 2, children: sampleChildren),
            Dashboard_Menu_Items(title: "Site", imageName: "house", itemCount: 0, children: nil) // ✅ Back test button
        ]

        return Dashboard_Menu_Collection(
            assignments: assignments,
            showToast: $showToast,
            toastMessage: $toastMessage,
            selectedAssignment: $selectedAssignment,
            showSheet: $showSheet,
            path: $path
        )
    }
}


