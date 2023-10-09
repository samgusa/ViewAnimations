//
//  Tab.swift
//  TabBarTest
//
//  Created by Sam Greenhill on 5/16/23.
//

import Foundation

enum Tabs: String, CaseIterable {
    case home = "Home"
    case services = "Services"
    case partners = "Partners"
    case activity = "Activity"

    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .services:
            return "envelope.open.badge.clock"
        case .partners:
            return "hand.raised"
        case .activity:
            return "bell"
        }
    }

    var index: Int {
        return Tabs.allCases.firstIndex(of: self) ?? 0
    }
}
