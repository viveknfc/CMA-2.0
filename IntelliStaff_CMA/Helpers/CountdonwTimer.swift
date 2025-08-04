//
//  CountdonwTimer.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 15/07/25.
//
import SwiftUI

@MainActor
class ResendTimerModel: ObservableObject {
    @Published var countdown = 0
    @Published var canResend = true

    private var timerTask: Task<Void, Never>?

    func start(duration: Int = 30) {
        timerTask?.cancel()
        countdown = duration
        canResend = false

        timerTask = Task {
            while countdown > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                countdown -= 1
            }
            canResend = true
        }
    }

    func cancel() {
        timerTask?.cancel()
        canResend = true
        countdown = 0
    }
}

