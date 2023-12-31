//
//  TabShape.swift
//  TabBarTest
//
//  Created by Sam Greenhill on 5/16/23.
//

import SwiftUI

/// Custom tab shape
struct TabShape: Shape {
    var midPoint: CGFloat

    /// Adding Shape Animation
    var animatableData: CGFloat {
        get { midPoint }
        set { midPoint = newValue }
    }

    func path(in rect: CGRect) -> Path {
        return Path { path in
            // first drawing the rectangle
            path.addPath(Rectangle().path(in: rect))
            // now drawing upward curve shape
            path.move(to: .init(x: midPoint - 60, y: 0))

            let to = CGPoint(x: midPoint, y: -25)
            let control1 = CGPoint(x: midPoint - 25, y: 0)
            let control2 = CGPoint(x: midPoint - 25, y: -25)

            path.addCurve(to: to, control1: control1, control2: control2)

            let to2 = CGPoint(x: midPoint + 60, y: 0)
            let control3 = CGPoint(x: midPoint + 25, y: -25)
            let control4 = CGPoint(x: midPoint + 25, y: 0)

            path.addCurve(to: to2, control1: control3, control2: control4)
            /// since we hav emoved out point +/- 60, you can also use 30 instead of value 25, but I am fine with 25.
            /// If you choose to change all the instances of +/- 25 to +/- 30 in the xaxis only

        }
    }
}
