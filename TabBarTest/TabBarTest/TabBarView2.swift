//
//  TabBarView2.swift
//  TabBarTest
//
//  Created by Sam Greenhill on 4/28/23.
//

import SwiftUI

struct TabBarView2: View {
    let bgColor: Color = .init(white: 0.9)
    var body: some View {
        TabsLayoutView()
            .padding( )
            .background(
                Capsule()
                    .fill(.white)
            )
            .frame(height: 70)
            .shadow(radius: 30)
    }
}

fileprivate struct TabsLayoutView: View {
    @State var selectedTab: Tab = .home
    @Namespace var namespace

    var body: some View {
        HStack {
            ForEach(Tab.allCases) { tab in
                TabButton(tab: tab, selectedTab: $selectedTab, namespace: namespace)
            }
        }
    }

    private struct TabButton: View {
        let tab: Tab
        @Binding var selectedTab: Tab
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
                            .fill(tab.color.opacity(0.2))
                            .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                    }
                    HStack(spacing: 10) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(isSelected ? tab.color : .black.opacity(0.6))
                            .scaleEffect(isSelected ? 1 : 0.9)
                            .opacity(isSelected ? 1 : 0.7)
                            .padding(.leading, isSelected ? 20 : 0)
                            .padding(.horizontal, selectedTab != tab ? 10 : 0)

                        if isSelected {
                            Text(tab.title)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(tab.color)
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
            .buttonStyle(.plain)
        }

        private var isSelected: Bool {
            selectedTab == tab
        }
    }
    
}

struct TabBarView2_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView2()
    }
}
