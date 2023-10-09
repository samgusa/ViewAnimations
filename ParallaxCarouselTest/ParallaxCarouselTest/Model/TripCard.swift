//
//  TripCard.swift
//  ParallaxCarouselTest
//
//  Created by Sam Greenhill on 10/4/23.
//

import SwiftUI

// Trip Card Model
struct TripCard: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}

// Sample Cards
var tripCards: [TripCard] = [
    .init(title: "London", subTitle: "England", image: "Pic 1"),
    .init(title: "New York", subTitle: "USA", image: "Pic 2"),
    .init(title: "Prague", subTitle: "Czech Republic", image: "Pic 3"),
]
