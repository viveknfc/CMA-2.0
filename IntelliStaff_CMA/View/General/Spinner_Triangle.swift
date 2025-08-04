//
//  Spinner_Triangle.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 15/07/25.
//

import SwiftUI

// MARK: - Triangle State Enum
enum TriangleState {
    case begin, phaseOne, phaseTwo, stop

    func getStrokes() -> (CGFloat, CGFloat) {
        switch self {
        case .begin: return (0.335, 0.665)
        case .phaseOne: return (0.5, 0.825)
        case .phaseTwo: return (0.675, 1)
        case .stop: return (0.175, 0.5)
        }
    }

    func getCircleOffset() -> (CGFloat, CGFloat) {
        switch self {
        case .begin:
            return (0, 20)
        case .phaseOne:
            return (20, -5)
        case .phaseTwo:
            return (-20, -5)
        case .stop:
            return (-20, 0)
        }
    }
}

// MARK: - Triangle Shape
struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

// MARK: - Triangle Loader View
struct TriangleLoader: View {
    @State private var strokeStart: CGFloat = 0
    @State private var strokeEnd: CGFloat = 0
    @State private var circleOffset: CGSize = CGSize(width: 0, height: 0)

    let animationDuration: TimeInterval = 0.7
    var circleColor: Color = .red

    var body: some View {
        ZStack {

            ZStack {
                TriangleShape()
                    .trim(from: strokeStart, to: strokeEnd)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.theme)

                Circle()
                    .fill(circleColor)
                    .frame(width: 8, height: 8)
                    .offset(circleOffset)
            }
            .frame(width: 60, height: 60)
            .offset(y: -75)
        }
        .onAppear {
            animateCycle()
            Timer.scheduledTimer(withTimeInterval: animationDuration * 4.5, repeats: true) { _ in
                animateCycle()
            }
        }
    }

    // MARK: - Animation Sequence
    private func animateCycle() {
        Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animationDuration)) {
                setStroke(state: .phaseOne)
            }
            
            withAnimation(.spring(response: animationDuration * 2, dampingFraction: 0.85)) {
                setCircleOffset(state: .phaseOne)
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 2 , repeats: false) { _ in
            withAnimation(.easeInOut(duration: animationDuration)) {
                setStroke(state: .phaseTwo)
            }
            
            withAnimation(.spring(response: animationDuration * 2, dampingFraction: 0.85)) {
                setCircleOffset(state: .phaseTwo)
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 3.5, repeats: false) { _ in
            setStroke(state: .stop)
            
            withAnimation(.easeInOut(duration: animationDuration)) {
                setStroke(state: .begin)
            }
            
            withAnimation(.spring(response: animationDuration * 2, dampingFraction: 0.85)) {
                setCircleOffset(state: .begin)
            }
        }
    }

    func setStroke(state: TriangleState) {
        (self.strokeStart, self.strokeEnd) = state.getStrokes()
    }
    
    func setCircleOffset(state: TriangleState) {
        let offset = state.getCircleOffset()
        self.circleOffset = CGSize(width: offset.0, height: offset.1)
    }
}

// MARK: - Preview
struct TriangleLoader_Previews: PreviewProvider {
    static var previews: some View {
                TriangleLoader()
                    .preferredColorScheme(.dark)
    }
}

