//
//  AlertView.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 15/07/25.
//

import SwiftUI

enum AlertType {
    case success
    case error
    
    struct Theme {
        var background: Color
        var titleColor: Color
        var messageColor: Color
        var buttonBackground: Color
        var buttonText: Color
        var secondaryButtonBackground: Color
        var secondaryButtonText: Color
        
        static let `default` = Theme(
            background: Color.white,
            titleColor: .black,
            messageColor: .gray,
            buttonBackground: .theme,
            buttonText: .white,
            secondaryButtonBackground: .gray.opacity(0.3),
            secondaryButtonText: .black
        )
    }
    
    var theme: Theme {
        switch self {
        case .success:
            return Theme(
                background: Color.green.opacity(0.1),
                titleColor: .green,
                messageColor: .black.opacity(0.7),
                buttonBackground: .green,
                buttonText: .white,
                secondaryButtonBackground: .gray.opacity(0.3),
                secondaryButtonText: .black
            )
            
        case .error:
             return Theme(
            background: Color(red: 1.0, green: 0.97, blue: 0.96),   // soft coral tint
            titleColor: Color(red: 0.85, green: 0.25, blue: 0.25), // coral red
            messageColor: .black.opacity(0.7),
            buttonBackground: Color(red: 0.95, green: 0.35, blue: 0.35), // coral button
            buttonText: .white,
            secondaryButtonBackground: .gray.opacity(0.25),
            secondaryButtonText: .black
        )

        }
    }
}

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
    
    var alertType: AlertType? = nil
    
    private var theme: AlertType.Theme {
        alertType?.theme ?? .default
    }

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
                }
//                else {
//                    Image(systemName: "exclamationmark.circle")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 40, height: 40)
//                        .foregroundColor(theme.titleColor)
//                }

                // Title
                if let title = title {
                    Text(title)
                        .font(.titleFont)
                        .foregroundColor(theme.titleColor)
                        .multilineTextAlignment(.center)
                }

                // Body message
                if let message = message {
                    Text(message)
                        .font(.bodyFont)
                        .foregroundColor(theme.messageColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Buttons
                if let second = secondaryButton {
                    HStack(spacing: 12) {
                        buttonView(config: second, bgColor: theme.secondaryButtonBackground, textColor: theme.secondaryButtonText)
                        buttonView(config: primaryButton, bgColor: theme.buttonBackground, textColor: theme.buttonText)
                    }
                } else {
                    buttonView(config: primaryButton, bgColor: theme.buttonBackground, textColor: theme.buttonText)
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
