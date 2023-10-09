//
//  ContentView.swift
//  LiquidButtonTest
//
//  Created by Sam Greenhill on 4/27/23.
//

import SwiftUI

struct ContentView: View {
    @State var offsetOne: CGSize = .zero
    @State var offsetTwo: CGSize = .zero
    @State private var isCollapsed: Bool = false


    var body: some View {
        ZStack {
            BackgroundView()
            LiquidMenu()
        }
    }
}

extension ContentView {

    private func BackgroundView() -> some View {
        Rectangle()
            .fill(.linearGradient(colors: [.black.opacity(0.9), .black, .black.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .edgesIgnoringSafeArea(.all)
    }


    private func LiquidMenu() -> some View {
        ZStack {
            Rectangle()
                .fill(.linearGradient(colors: [.purple, .pink], startPoint: .top, endPoint: .bottom))
                .mask {
                    Canvas { context, size in
                        // adding filters
                        context.addFilter(.alphaThreshold(min: 0.8, color: .black))
                        //this blur filter is what gives that liquid like motion. 
                        context.addFilter(.blur(radius: 8))

                        // Drawing Layers
                        context.drawLayer { ctx in
                            //placing symbols
                            for index in [1, 2, 3] {
                                if let resolvedView = context.resolveSymbol(id: index) {
                                    ctx.draw(resolvedView, at: CGPoint(x: size.width/2, y: size.height/2))
                                }
                            }
                        }
                    } symbols: {
                        Symbol(diameter: 120)
                            .tag(1)

                        Symbol(offset: offsetOne)
                            .tag(2)

                        Symbol(offset: offsetTwo)
                            .tag(3)

                    }
                }

            // Blendmode is just for adding the gradient color for the image on each button.
            // Offset here is for the image, if not implemented it will all show up with the x + button.
            // opacity so that all the images dont all appear on top of each other when not open.
            CancelButton()
                //.blendMode(.softLight)
                .rotationEffect(Angle(degrees: isCollapsed ? 90 : 45))
            SettingsButton()
                .offset(offsetOne)
                //.blendMode(.softLight)
                .opacity(isCollapsed ? 1 : 0)
            HomeButton()
                .offset(offsetTwo)
                //.blendMode(.softLight)
                .opacity(isCollapsed ? 1 : 0)
        }
        .frame(width: 120, height: 500)
        .contentShape(Circle())
    }

    private func Symbol(offset: CGSize = .zero, diameter: CGFloat = 75) -> some View {
        Circle()
            .frame(width: diameter, height: diameter)
            .offset(offset)
    }

    func HomeButton() -> some View {
        ZStack {
            Image(systemName: "house")
                .resizable()
                .frame(width: 25, height: 25)
        }
        .frame(width: 65, height: 65)
    }

    func CancelButton() -> some View {
        ZStack {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 35, height: 35)
                .aspectRatio(.zero, contentMode: .fit).contentShape(Circle())
        }
        .frame(width: 100, height: 100)
        .contentShape(Rectangle())
        .onTapGesture {
            print("----- Cancel Tapped ----")

            withAnimation { isCollapsed.toggle() }
            withAnimation(.interactiveSpring(response: 0.35, dampingFraction: 0.8, blendDuration: 0.1).speed(0.5)) {
                offsetOne = isCollapsed ? CGSize(width: 0, height: -120) : .zero
                offsetTwo = isCollapsed ? CGSize(width: 0, height: -205) : .zero
            }
        }
    }

    func SettingsButton() -> some View {
        ZStack {
            Image(systemName: "gear")
                .resizable()
                .frame(width: 28, height: 28)
        }
        .frame(width: 65, height: 65)
    }



}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
