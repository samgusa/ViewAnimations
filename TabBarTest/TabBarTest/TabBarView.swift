//
//  TabBarView.swift
//  TabBarTest
//
//  Created by Sam Greenhill on 4/27/23.
//

import SwiftUI

let backgroundColor = Color.init(white: 0.92)

struct TabBarView: View {
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.white)
                    .shadow(color: .gray.opacity(0.4), radius: 20, x: 0, y: 20)

                TabsLayoutView()
            }
            .frame(height: 70, alignment: .center)
            .padding(.bottom, 0)
        }
    }
}

fileprivate struct TabsLayoutView: View {
    @State var selectedTab: Tab = .home
    @Namespace var namespace

    var body: some View {
        HStack {
            Spacer(minLength: 0)

            ForEach(Tab.allCases) { tab in
                TabButton(tab: tab, selectedTab: $selectedTab, namespacer: namespace)
                    .frame(width: 65, height: 65, alignment: .center)
                Spacer()
            }
        }
    }

    private struct TabButton: View {
        let tab: Tab
        @Binding var selectedTab: Tab
        var namespacer: Namespace.ID

        var body: some View {
            Button {
                withAnimation {
                    selectedTab = tab
                }
            } label: {
                ZStack {
                    if isSelected {
                        Circle()
                            .shadow(radius: 10)
                            .background {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .foregroundColor(backgroundColor)
                            }
                            .offset(y: -40)
                            .matchedGeometryEffect(id: "Selected tab", in: namespacer)
                            //.animation(.spring(), value: selectedTab)
                    }

                    Image(systemName: tab.icon)
                        .font(.system(size: 23, weight: .semibold, design: .rounded))
                        .foregroundColor(isSelected ? .init(white: 0.9) : .gray)
                        .scaleEffect(isSelected ? 1 : 0.8)
                        .offset(y: isSelected ? -40 : 0)
//                        .animation(isSelected ? .spring(response: 0.5, dampingFraction: 0.3, blendDuration: 1) : .spring(), value: selectedTab)
                }
            }
            .buttonStyle(.plain)
        }


        private var isSelected: Bool {
            selectedTab == tab
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
