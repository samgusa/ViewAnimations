//
//  Home.swift
//  AnimatedTabsTest
//
//  Created by Sam Greenhill on 10/12/23.
//

import SwiftUI

struct Home: View {
    // View Properties
    @State private var activeTab: Tab = .photos
    // All Tabs
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    // Bounce Property
    @State private var bounceDown: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            // Now that the custom tab is built, by hiding the native tab bar, we can add cool animations to the icons using iOS 17 Symbol Effects
            TabView(selection: $activeTab) {
                NavigationStack {
                    VStack {

                    }
                    .navigationTitle(Tab.photos.title)
                }
                .setUpTab(.photos)

                NavigationStack {
                    VStack {

                    }
                    .navigationTitle(Tab.chat.title)
                }
                .setUpTab(.chat)

                NavigationStack {
                    VStack {

                    }
                    .navigationTitle(Tab.apps.title)
                }
                .setUpTab(.apps)

                NavigationStack {
                    VStack {

                    }
                    .navigationTitle(Tab.notifications.title)
                }
                .setUpTab(.notifications)

                NavigationStack {
                    VStack {

                    }
                    .navigationTitle(Tab.profile.title)
                }
                .setUpTab(.profile)
            }
            // Just for demo purpose
            Picker("", selection: $bounceDown) {
                Text("Bounces Down")
                    .tag(true)

                Text("Bounces up")
                    .tag(false)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 15)
            .padding(.bottom, 20)
            CustomTabBar()
        }
    }

    /// Custom Tab Bar
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                    // iOS 17 allows us to create SF symbols in a different way, such as discrete, indefinite, etc.
                    // the reason why the animation occurs twice is that the symbolEffect modifier animated the image when the value changes. To avoid this, we can use Transation() to tell SwiftUI to disable animation for this particular transaction.
                        .symbolEffect(bounceDown ? .bounce.down.byLayer : .bounce.up.byLayer, value: animatedTab.isAnimating)

                    Text(tab.title)
                        .font(.caption2)
                        .textScale(.secondary)
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(activeTab == tab ? Color.primary : Color.gray.opacity(0.8))
                .padding(.top, 15)
                .padding(.bottom, 20)
                .contentShape(.rect)
                // You can Also use Button, if you choose
                .onTapGesture {
                    // the reason we wrapped the animation inside the new withAnimation completion handler, so that we can reset the status to nil once that animation completes
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete, {
                        activeTab = tab
                        animatedTab.isAnimating = true
                    }, completion: {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animatedTab.isAnimating = nil
                        }
                    })
                }
            }
        }
        .background(.bar)
    }
}

#Preview {
    ContentView()
}

extension View {
    @ViewBuilder
    func setUpTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}
