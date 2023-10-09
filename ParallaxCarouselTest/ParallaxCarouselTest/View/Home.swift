//
//  Home.swift
//  ParallaxCarouselTest
//
//  Created by Sam Greenhill on 10/4/23.
//

import SwiftUI

struct Home: View {
    // View Properties
    @State private var searchText: String = ""

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                            .foregroundColor(.blue)
                    }

                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search", text: $searchText)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                }

                Text("Where do you want to \ntravel?")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)

                // Parallax Carousel
                GeometryReader { geometry in
                    let size = geometry.size

                    ScrollView(.horizontal) {
                        HStack(spacing: 5) {
                            ForEach(tripCards) { card in
                                // In order to Move the Card in Reverse Direction [Parallax Effect]
                                GeometryReader { proxy in
                                    let cardSize = proxy.size
                                    // Simple Parallax Effect (1)
                                    let minX = proxy.frame(in: .scrollView).minX
                                    // What is going on here, in the past i've moved exactly the same amount of minX in the reverse direction, which leads to Effect 2. in order to acheive Effect 1, i'm going to speed up the minX in the reverse direction, which may lead to an empty view while scrolling. To avoid that, im going to increase the image size horizontally.
//                                    let minX = min((proxy.frame(in: .scrollView).minX * 1.4), proxy.size.width * 1.4)

                                    Image(card.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                    // Or you can simply use scaling
                                        //.scaleEffect(1.25)
                                    // Parallax Carousel 2
                                        .offset(x: -minX)
                                        .frame(width: proxy.size.width * 2.5)
                                        .frame(width: cardSize.width, height: cardSize.height)
                                        .overlay {
                                            OverlayView(card)
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                }
                                // Since i've applied horizontal padding of 30, which means 60, which is why i've reduced 60 from card width. 30 from both sides
                                .frame(width: size.width - 60, height: size.height - 50)
                                // Scroll Animation
                                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                    view
                                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .scrollTargetLayout()
                        .frame(height: size.height, alignment: .top)
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                }
                .frame(height: 500)
                .padding(.horizontal, -15)
                .padding(.top, 10)


            }
            .padding(15)
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    func OverlayView(_ card: TripCard) -> some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.5),
                .black
            ], startPoint: .top, endPoint: .bottom)

            VStack(alignment: .leading, spacing: 4) {
                Text(card.title)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.white)

                Text(card.subTitle)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(20)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
