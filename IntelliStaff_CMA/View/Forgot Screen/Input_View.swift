//
//  Input_View.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 15/07/25.
//

import SwiftUI

struct SixBoxInputView: View {
    @Binding var inputs: [String]
    @FocusState var focusedIndex: Int?

    var body: some View {
        VStack(spacing: 20) {  // Wrap everything inside VStack
            HStack(spacing: 25) {
                ForEach(0..<6) { index in
                    TextField("", text: Binding(
                        get: { self.inputs[index] },
                        set: { newValue in
                            if newValue.count <= 1 {
                                self.inputs[index] = newValue
                                if !newValue.isEmpty {
                                    focusedIndex = index < 5 ? index + 1 : nil
                                }
                            }
                        }
                    ))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 40, height: 40)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    .focused($focusedIndex, equals: index)
                    .onChange(of: inputs[index]) { oldValue, newValue in
                        if newValue.isEmpty && index > 0 {
                            focusedIndex = index - 1
                        }
                    }
                }
            }

            Button("Reset") {
                inputs = Array(repeating: "", count: 6)
                focusedIndex = nil       // Clear focus first
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    focusedIndex = 0     // Then set focus again
                }
            }
            .foregroundStyle(.theme)
            .font(.buttonFont)

        }
        .onAppear {
            focusedIndex = 0
        }
    }
}



#Preview {
    struct SixBoxInputViewPreviewWrapper: View {
        @State private var inputs: [String] = Array(repeating: "", count: 6)
        @FocusState private var focusedIndex: Int?

        var body: some View {
            SixBoxInputView(inputs: $inputs, focusedIndex: _focusedIndex)
                .padding()
        }
    }

    return SixBoxInputViewPreviewWrapper()
}

