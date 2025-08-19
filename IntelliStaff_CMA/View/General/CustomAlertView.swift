//
//  CustomAlertView.swift
//  IntelliStaff_CMA
//
//  Created by ios on 19/08/25.
//

import SwiftUI

import SwiftUI

struct CustomAlertView: View {
    @Binding var show: Bool
    
    var body: some View {
        if show {
            ZStack {
                // Background Dimmed
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { show = false }
                    }
                
                // Alert Box
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation { show = false }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.clear)
                                .clipShape(Circle())
                        }
                    }
                    
                    // Legend Rows
                    legendRow(color: .yellow, text: "Non Check In and Check Out")
                    legendRow(color: .orange, text: "Time Changed After Check Out")
                    legendRow(color: .green, text: "Employee Check In Only")
                    legendRow(color: .pink, text: "Employee Completed Check Out")
                    
                }
                .padding()
                .background(Color(hex: "#111184"))
                .cornerRadius(16)
                .padding(.horizontal, 40)
                .shadow(radius: 10)
                .transition(.scale)
            }
        }
    }
    
    // Reusable row for legend
    private func legendRow(color: Color, text: String) -> some View {
        HStack {
            Rectangle()
                .fill(color.opacity(0.7))
                .frame(width: 20, height: 20)
                .cornerRadius(4)
            
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
        }
    }
}




struct SuccessAlertView: View {
    @Binding var show: Bool
    var message: String
    
    var body: some View {
        if show {
            ZStack {
                // Dimmed background
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { show = false }
                    }
                
                VStack(spacing: 20) {
                    Text(message)
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(12)
                    
                    Button(action: {
                        withAnimation {
                            show = false
                        }
                    }) {
                        Text("OK")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                .frame(maxWidth: 300)
                .transition(.scale)
            }
        }
    }
}




