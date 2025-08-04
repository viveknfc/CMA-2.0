//
//  Spalsh_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 14/07/25.
//

import SwiftUI

struct Spalsh_Screen: View {
    
    @State private var isActive = false
    
    var body: some View {
        
        if isActive {
            ContentView()
        } else {
                Image("Splash")
                .resizable()
                .scaledToFit()
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.white)) //"Theme Color"
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        withAnimation {
                            self.isActive = true
                        }

                    }
                }
        }
    }
}

#Preview {
    Spalsh_Screen()
        .environmentObject(GlobalErrorHandler())
}
