//
//  Rectangle_Container.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 20/07/25.
//

import SwiftUI

struct Rectangle_Container<Content: View>: View {
    let alignment: Alignment
    let content: Content

    init(alignment: Alignment = .center, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: alignment) {
            Rectangle()
                .fill(Color.white) // full plain background
                .shadow(radius: 5)
            content
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

#Preview(traits: .sizeThatFitsLayout) {
    Rectangle_Container {
        VStack {
            Image(systemName: "star.fill")
                .foregroundColor(.black)
            Text("Preview Content")
                .foregroundColor(.black)
        }
        .padding()
    }
}


