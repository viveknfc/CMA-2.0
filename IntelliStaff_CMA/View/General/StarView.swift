//
//  StarView.swift
//  IntelliStaff_CMA
//
//  Created by ios on 14/08/25.
//

import SwiftUI

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    
    var maxRating: Int = 5
    var filledImage: String = "star.fill"
    var emptyImage: String = "star"
    var starSize: CGFloat = 12
    var spacing: CGFloat = 4
    var isEditable: Bool = true
    var onRatingChanged: ((Int) -> Void)? = nil

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: star <= rating ? filledImage : emptyImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: starSize, height: starSize)
                    .foregroundColor(.theme)
                    .onTapGesture {
                        if isEditable {
                            rating = star
                            onRatingChanged?(star)
                        }
                    }
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Rating")
        .accessibilityValue("\(rating) out of \(maxRating) stars")
        .accessibilityAdjustableAction { direction in
            guard isEditable else { return }
            switch direction {
            case .increment:
                if rating < maxRating {
                    rating += 1
                    onRatingChanged?(rating)
                }
            case .decrement:
                if rating > 1 {
                    rating -= 1
                    onRatingChanged?(rating)
                }
            default:
                break
            }
        }
    }
}

struct RatingDemo: View {
    @State private var userRating = 3
    @State private var showFeedbackAlert = false
    @State private var feedbackText = ""

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Rate Your Shift")
                    .font(.headline)

                StarRatingView(rating: $userRating, onRatingChanged: { newRating in
                    if newRating <= 2 {
                        showFeedbackAlert = true
                    }
                })

                Text("You selected \(userRating) star\(userRating == 1 ? "" : "s")")
                    .foregroundColor(.gray)
            }
            .padding()
            .blur(radius: showFeedbackAlert ? 3 : 0)

            // Custom Alert Overlay
            if showFeedbackAlert {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Please tell us why your rating was low.")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    TextField("Enter your feedback...", text: $feedbackText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    HStack(spacing: 20) {
                        Button("Cancel") {
                            feedbackText = ""
                            showFeedbackAlert = false
                        }
                        .foregroundColor(.red)

                        Button("Submit") {
                            print("Submitted feedback: \(feedbackText)")
                            showFeedbackAlert = false
                        }
                        .disabled(feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(40)
                .shadow(radius: 10)
            }
        }
        .animation(.easeInOut, value: showFeedbackAlert)
    }
}

