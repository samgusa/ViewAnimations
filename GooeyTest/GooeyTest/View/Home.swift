//
//  Home.swift
//  GooeyTest
//
//  Created by Sam Greenhill on 5/29/23.
//

import SwiftUI

struct Home: View {
    var size: CGSize
    // View properties
    @State private var isExpanded: Bool = false
    @State private var radius: CGFloat = 10
    @State private var animatedRadius: CGFloat = 10
    @State private var scale: CGFloat = 1

    // Offsets - you can also use the base offset and secondary offset as a single bool value
    // instead of moving all four share buttons at once, we'll move the two buttons on the right and the two buttons on the left first. To do this, we'll use base offsets. Then in the following step, we'll expand by moving one button from the left and one button from the right. For this we'll use secondary offsets. As a result, all four share buttons will expand in a gooey way.
    @State private var baseOffset: [Bool] = Array(repeating: false, count: 5)
    @State private var secondaryOffset: [Bool] = Array(repeating: false, count: 2)
    // Icons will First visible on the Base offset and continue to secondary offset
    @State private var showIcons: [Bool] = [false, false]
    //@State private var dispatchTask: DispatchWorkItem?

    var body: some View {
        VStack {
            // Share Button
            // Since we have 5 buttons
            //Padding
            let padding: CGFloat = 30
            let circleSize = (size.width - padding) / 5
            ZStack {
                ShapeMorphingView(systemImage: isExpanded ? "xmark.circle.fill" : "square.and.arrow.up.fill", fontSize: isExpanded ? circleSize * 0.9 : 35, color: .white)
                    .scaleEffect(isExpanded ? 0.6 : 1)
                    .background {
                        Rectangle()
                            .fill(.gray.gradient)
                    }
                    .mask {
                        Canvas { ctx, size in
                            // same techniques as Shape Morph
                            ctx.addFilter(.alphaThreshold(min: 0.5))
                            ctx.addFilter(.blur(radius: animatedRadius))

                            //Drawing symbols
                            ctx.drawLayer { ctx1 in
                                // Since there are 5 Circles with 5 tags
                                for index in 0..<5 {
                                    if let resolvedShareButton = ctx.resolveSymbol(id: index) {
                                        ctx1.draw(resolvedShareButton, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                    }
                                }
                            }

                        } symbols: {
                            GroupedShareButton(size: circleSize, fillColor: true)
                        }
                    }
                GroupedShareButton(size: circleSize, fillColor: false)
            }
            .frame(height: circleSize)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: isExpanded) { newValue in
            if newValue {
                // First Displaying base offset icons
                withAnimation(.easeInOut(duration: 0.3).delay(0.1)) {
                    showIcons[0] = true
                }

                // Next Displaying Secondary offset icons
                withAnimation(.easeInOut(duration: 0.3).delay(0.2)) {
                    showIcons[1] = true
                }
            } else {
                // No delay for hiding icons
                withAnimation(.easeInOut(duration: 0.15)) {
                    showIcons[0] = false
                    showIcons[1] = false
                }
            }
        }
    }

    @ViewBuilder
    func GroupedShareButton(size: CGFloat, fillColor: Bool = true) -> some View {
        Group {
            ShareButton(size: size, tag: 0, icon: "Twitter", showIcon: showIcons[1]) {
                return (baseOffset[0] ? -size : 0) + (secondaryOffset[0] ? -size : 0)
            }
            .onTapGesture {
                print("Twitter")
            }
            ShareButton(size: size, tag: 1, icon: "Facebook", showIcon: showIcons[0]) {
                return (baseOffset[1] ? -size : 0)
            }
            .onTapGesture {
                print("Facebook")
            }
            ShareButton(size: size, tag: 2, icon: "", showIcon: true) {
                return 0
            }
            .zIndex(100)
            .onTapGesture {
                toggleShareButton()
            }
            // Making it Top of all Views, for initial tap

            ShareButton(size: size, tag: 3, icon: "Pinterest", showIcon: showIcons[0]) {
                return (baseOffset[3] ? size : 0)
            }
            .onTapGesture {
                print("Pinterest")
            }
            ShareButton(size: size, tag: 4, icon: "Gmail", showIcon: showIcons[1]) {
                return (baseOffset[4] ? size : 0) + (secondaryOffset[1] ? size : 0)
            }
            .onTapGesture {
                print("Gmail")
            }
        }
        .foregroundColor(fillColor ? .black : .clear)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animationProgress(endValue: radius) { value in
            animatedRadius = value
            if value >= 15 {
                withAnimation(.easeInOut(duration: 0.4)) {
                    radius = 10
                }
            }
        }
    }

    // tag is used in the canvas rendering, and canvas plays a major role in both shape and morph and gooey effect.
    // the offset section can be used to get the computed offset value for each share when it's expanded.
    @ViewBuilder
    func ShareButton(size: CGFloat, tag: Int, icon: String, showIcon: Bool, offset: @escaping () -> CGFloat) -> some View {
        Circle()
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .overlay {
                if icon != "" {
                    Image(icon)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: size * 0.3)
                    // showing icon when ShowIcon is true
                        .opacity(showIcon ? 1 : 0)
                        .scaleEffect(showIcon ? 1 : 0.001)
                }
            }
            .contentShape(Circle())
            .offset(x: offset())
            .tag(tag)
    }

    // Toggling share button
    func toggleShareButton() {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.4)) {
            isExpanded.toggle()
            scale = isExpanded ? 0.75 : 1
        }

        // Updating radius for more fluidity
        withAnimation(.easeInOut(duration: 0.4)) {
            radius = 20
        }

        for index in baseOffset.indices {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.8)) {
                baseOffset[index].toggle()
            }
        }
        // no delay needed for closing
        DispatchQueue.main.asyncAfter(deadline: .now() + (isExpanded ? 0.15 : 0)) {
            for index in secondaryOffset.indices {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.8)) {
                    secondaryOffset[index].toggle()
                }
            }
        }


    }

}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
