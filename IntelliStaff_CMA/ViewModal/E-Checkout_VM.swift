//
//  E-Checkout_VM.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 16/08/25.
//

import Foundation

@MainActor
@Observable
class ECheckout_VM {
    
    var checkoutData: [ECheckoutModal] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    func fetchCheckoutData() {
        checkoutData = [
            ECheckoutModal(
                name: "Vivek",
                position: "iOS",
                scheduledTime: Date(),
                selectedTime: Date()
            ),
            ECheckoutModal(
                name: "John",
                position: "Android",
                scheduledTime: Date().addingTimeInterval(3600),
                selectedTime: Date()
            ),
            ECheckoutModal(
                name: "Sarah",
                position: "Backend",
                scheduledTime: Date().addingTimeInterval(7200),
                selectedTime: Date()
            )
        ]
    }
}
