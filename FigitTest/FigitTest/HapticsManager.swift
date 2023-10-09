//
//  HapticsManager.swift
//  FigitTest
//
//  Created by Sam Greenhill on 4/25/23.
//

import Foundation
import UIKit

class HapticsManager {

    static let shared = HapticsManager()

    private var lightImpactGenerator: UIImpactFeedbackGenerator?

    private init() {
        lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
        lightImpactGenerator?.prepare()
    }

    func generateFeedback() {
        lightImpactGenerator?.impactOccurred()
    }
}
