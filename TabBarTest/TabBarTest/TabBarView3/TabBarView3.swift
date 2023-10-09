//
//  TabBarView3.swift
//  TabBarTest
//
//  Created by Sam Greenhill on 5/16/23.
//

import SwiftUI

struct TabBarView3: View {
    @State private var activeTab: Tabs = .home
    // for smooth shape sliding effect, we're going to use Matched geometry effect.
    @Namespace private var animation
    @State private var tabShapePosition: CGPoint = .zero
    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                Text("Home")
                    .tag(Tabs.home)
                /// hiding navite tab bar
                    ///.toolbar(.hidden, for: .tabBar)

                Text("Services")
                    .tag(Tabs.services)
                /// hiding navite tab bar
                    ///.toolbar(.hidden, for: .tabBar)

                Text("Partners")
                    .tag(Tabs.partners)
                /// hiding navite tab bar
                    ///.toolbar(.hidden, for: .tabBar)

                Text("Activity")
                    .tag(Tabs.activity)
                /// hiding navite tab bar
                    ///.toolbar(.hidden, for: .tabBar)
            }
            SecondTabBar()
                .frame(height: 100)
        }
    }

    @ViewBuilder
    func SecondTabBar(_ tint: Color = Color.blue, _ inactiveTint: Color = Color.black) -> some View {
        /// Moving all the remaining tab items to the bottom
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tabs.allCases, id: \.rawValue) {
                TabButton2(
                    tab: $0,
                    selectedTab: $activeTab,
                    namespace: animation)
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 5)
        .background {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
            /// Adding blur + shadow
            /// for shape smoothing
                .shadow(color: tint.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
        }
        /// adding Animation
        .animation(.default, value: activeTab)
    }

@ViewBuilder
    func CustomTabBar(_ tint: Color = Color.blue, _ inactiveTint: Color = Color.black) -> some View {
        /// Moving all the remaining tab items to the bottom
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tabs.allCases, id: \.rawValue) {
                TabsItem(
                    tint: tint,
                    inactiveTint: inactiveTint,
                    tab: $0,
                    animation: animation,
                    activeTab: $activeTab,
                    position: $tabShapePosition
                )
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background {
            TabShape(midPoint: tabShapePosition.x)
                .fill(.white)
                .ignoresSafeArea()
            /// Adding blur + shadow
            /// for shape smoothing
                .shadow(color: tint.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
                .padding(.top, 25)
        }
        /// adding Animation
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
}

private struct TabButton2: View {
    let tab: Tabs
    @Binding var selectedTab: Tabs
    var namespace: Namespace.ID

    var body: some View {
        Button {
            withAnimation(.default) {
                selectedTab = tab
            }
        } label: {
            ZStack {
                if isSelected {
                    Capsule()
                        .fill(Color.blue.opacity(0.6))
                        .frame(height: 40)
                        .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                }
                HStack(spacing: 10) {
                    Image(systemName: tab.systemImage)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(isSelected ? Color.white : .black.opacity(0.6))
                        .scaleEffect(isSelected ? 1 : 0.9)
                        .opacity(isSelected ? 1 : 0.7)
                        .padding(.horizontal, selectedTab != tab ? 20 : 0)

                    if isSelected {
                        Text(tab.rawValue)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.white)
                            .padding(.trailing, 10)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var isSelected: Bool {
        selectedTab == tab
    }
}

private struct TabButton: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tabs
    var animation: Namespace.ID
    @Binding var activeTab: Tabs
    @Binding var position: CGPoint

    /// Each tab item position on the screen.
    @State private var tabPosition: CGPoint = .zero

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .white : tint)
                .scaleEffect(activeTab == tab ? 1 : 0.9)
                .opacity(activeTab == tab ? 1 : 0.7)
                .padding(.leading, activeTab == tab ? 20 : 0)
                .padding(.horizontal, activeTab != tab ? 10 : 0)
            if activeTab == tab {
                Text(tab.rawValue)
                    .font(.caption)
                    .foregroundColor(activeTab == tab ? .white : .gray)
                    .padding(.trailing, 20)
            }
        }
        .background {
            if activeTab == tab {
                Capsule()
                    .fill(tint.gradient)
                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.default) {
                activeTab = tab
            }
        }
    }
}

struct TabsItem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tabs
    var animation: Namespace.ID
    @Binding var activeTab: Tabs
    @Binding var position: CGPoint

    /// Each tab item position on the screen.
    @State private var tabPosition: CGPoint = .zero

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .white : tint)
            /// increasing size for the active tab
                .frame(width: activeTab == tab ? 50 : 35, height: activeTab == tab ? 50 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }

            Text(tab.rawValue)
                .font(.caption)
                .foregroundColor(activeTab == tab ? tint : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .viewPosition(completion: { rect in
            tabPosition.x = rect.midX

            /// updating Active tab position
            if activeTab == tab {
                position.x = rect.midX
            }
        })
        .onTapGesture {
            activeTab = tab
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                position.x = tabPosition.x
            }
        }
    }

}

struct TabBarView3_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView3()
    }
}
