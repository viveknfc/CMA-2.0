//
//  IntelliStaff_EMAApp.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 14/07/25.
//

import SwiftUI

@main
struct IntelliStaff_CMAApp: App {
    
    @StateObject private var errorHandler = GlobalErrorHandler()
    
    init() {
        NetworkMonitor.start() // ✅ Start monitoring here
    }
    
    var body: some Scene {
        WindowGroup {
            Spalsh_Screen()
                .environmentObject(errorHandler)
        }
    }
}
