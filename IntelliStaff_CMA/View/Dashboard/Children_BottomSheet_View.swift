//
//  Children_BottomSheet_View.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 21/07/25.
//

import SwiftUI

struct Children_BottomSheet_View: View {
    let parentTitle: String
    let children: [ChildItem]
    let onDismiss: () -> Void
    @Binding var path: [AppRoute]

    var body: some View {
        VStack(spacing: 10) {
            // Custom Header
            ZStack {
                
                Text(parentTitle)
                    .font(.titleFont)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        onDismiss()
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.theme)
                            .font(.title2)
                    }
                    .padding(.trailing, 25)
                }

            }   .padding(.top, 16)
                .background(Color(.systemBackground))

            Divider()

            // Scrollable list with dotted separators
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(children) { child in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                
                                Image(child.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                
                                Text(child.name)
                                    .font(.buttonFont)

                            }              .padding(.horizontal, 32)
                                .padding(.top, 12)

                            DottedLine()
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 8]))
                                .foregroundColor(.gray)
                                .frame(height: 1)
                                .padding(.horizontal, 32)
                                .padding(.bottom, 4)
                        }
                        .onTapGesture {
                            print("the api key is \(child.apiKey)")
                            path.append(.webView(apiKey: child.apiKey))
                        }
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    struct ChildrenBottomSheetPreviewWrapper: View {
        @State private var dummyPath: [AppRoute] = []

        var body: some View {
            Children_BottomSheet_View(
                parentTitle: "Math Subjects",
                children: [
                    ChildItem(name: "Algebra", apiKey: "algebra123"),
                    ChildItem(name: "Geometry", apiKey: "geometry456"),
                    ChildItem(name: "Trigonometry", apiKey: "trig789")
                ],
                onDismiss: { print("Dismissed") },
                path: $dummyPath
            )
        }
    }

    return ChildrenBottomSheetPreviewWrapper()
}


