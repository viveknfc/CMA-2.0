//
//  AlertView.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 15/07/25.
//

import SwiftUI

struct AlertButtonConfig {
    var title: String
    var action: () -> Void
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct AlertView: View {
    var image: Image?
    var title: String?
    var message: String?
    var primaryButton: AlertButtonConfig
    var secondaryButton: AlertButtonConfig?
    var dismiss: () -> Void

    var body: some View {
        ZStack {

            VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            VStack(spacing: 14) {
                if let img = image {
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                } else {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.theme)
                }

                // Title
                if let title = title {
                    Text(title)
                        .font(.titleFont)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }

                // Body message
                if let message = message {
                    Text(message)
                        .font(.bodyFont)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Buttons
                if let second = secondaryButton {
                    HStack(spacing: 12) {
                        buttonView(config: second, bgColor: .gray.opacity(0.3), textColor: .black)
                        buttonView(config: primaryButton, bgColor: .theme, textColor: .white)
                    }
                } else {
                    buttonView(config: primaryButton, bgColor: .theme, textColor: .white)
                }
            }
            .padding(.vertical, 22)
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 8)
            .padding(.horizontal, 24)
        }
    }
    
    @ViewBuilder
    private func buttonView(config: AlertButtonConfig, bgColor: Color, textColor: Color) -> some View {
        Button(action: {
            dismiss()
            config.action()
        }) {
            Text(config.title)
                .font(.buttonFont)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(bgColor)
                .foregroundColor(textColor)
                .cornerRadius(10)
        }
    }
    
}

#Preview {
    AlertView(image: nil,
              title: "Alert",
              message: "We have something to say",
              primaryButton: AlertButtonConfig(title: "Ok", action: {}),
              secondaryButton: AlertButtonConfig(title: "Cancel", action: {}),
              dismiss: {})
}
