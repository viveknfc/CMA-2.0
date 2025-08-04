//
//  Input_View.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 15/07/25.
//

import SwiftUI

struct FourBoxInputView: View {
    @Binding var inputs: [String]
    @FocusState var focusedIndex: Int?

    var body: some View {
        VStack(spacing: 20) {  // Wrap everything inside VStack
            HStack(spacing: 25) {
                ForEach(0..<4) { index in
                    TextField("", text: Binding(
                        get: { self.inputs[index] },
                        set: { newValue in
                            if newValue.count <= 1 {
                                self.inputs[index] = newValue
                                if !newValue.isEmpty {
                                    focusedIndex = index < 3 ? index + 1 : nil
                                }
                            }
                        }
                    ))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 60, height: 60)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .focused($focusedIndex, equals: index)
                    .onChange(of: inputs[index]) { oldValue, newValue in
                        if newValue.isEmpty && index > 0 {
                            focusedIndex = index - 1
                        }
                    }
                }
            }

            Button("Reset") {
                inputs = Array(repeating: "", count: 4)
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
    struct FourBoxInputViewPreviewWrapper: View {
        @State private var inputs: [String] = Array(repeating: "", count: 4)
        @FocusState private var focusedIndex: Int?

        var body: some View {
            FourBoxInputView(inputs: $inputs, focusedIndex: _focusedIndex)
                .padding()
        }
    }

    return FourBoxInputViewPreviewWrapper()
}

