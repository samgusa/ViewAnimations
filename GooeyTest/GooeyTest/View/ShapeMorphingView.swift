//
//  ShapeMorphingView.swift
//  GooeyTest
//
//  Created by Sam Greenhill on 5/30/23.
//

import SwiftUI

// Custom view which will morph given sfsymbol images.
//
struct ShapeMorphingView: View {
    var systemImage: String
    var fontSize: CGFloat
    var color: Color = .white
    var duration: CGFloat = 0.5
    // View Properties
    @State private var newImage: String = ""
    @State private var radius: CGFloat = 0
    @State private var animatedRadiusValue: CGFloat = 0
    var body: some View {
        GeometryReader {
            let size = $0.size
            Canvas { ctx, size in
                ctx.addFilter(.alphaThreshold(min: 0.5, color: color))
                ctx.addFilter(.blur(radius: animatedRadiusValue))

                ctx.drawLayer { ctx1 in
                    if let resolvedImageView = ctx.resolveSymbol(id: 0) {
                        ctx1.draw(resolvedImageView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                    }
                }
            } symbols: {
                ImageView(size: size)
                    .tag(0)
            }
        }
        // Initial Image Setting
        .onAppear {
            if newImage == "" {
                newImage = systemImage
            }
        }
        // Updating image
        .onChange(of: systemImage) { newValue in
            newImage = newValue
            withAnimation(.linear(duration: duration).speed(2)) {
                radius = 12
            }
        }
        .animationProgress(endValue: radius) { value in
            animatedRadiusValue = value

            if value >= 6 {
                withAnimation(.linear(duration: duration).speed(2)) {
                    radius = 0
                }
            }
        }

    }

    @ViewBuilder
    func ImageView(size: CGSize) -> some View {
        if newImage != "" {
            Image(systemName: systemImage)
                .font(.system(size: fontSize))
            //animation changes
            // animation values are upto your customization
            // Dont need to use both of these, but use .linear(duration: duration)
                .animation(.linear(duration: duration), value: duration)
//                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.9, blendDuration: 0.9), value: newImage)
//                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.9, blendDuration: 0.9), value: fontSize)
            // Fixing place at one point
                .frame(width: size.width, height: size.height)

        }
    }
}

struct ShapeMorphingView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
