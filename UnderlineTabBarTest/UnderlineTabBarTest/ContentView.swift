//
//  ContentView.swift
//  UnderlineTabBarTest
//
//  Created by Sam Greenhill on 6/9/23.
//

import SwiftUI

struct ContentView: View {
    @State var currentTab: Int = 0
    @Namespace var namespace
    var tabItems: [String] = ["Hello World", "This is", "A good Effect"]

    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: self.$currentTab) {
                view1.tag(0)
                view2.tag(1)
                view3.tag(2)
            }
            // tabviewstyle allows us to swipe between the tabs, and get rid of bottom dots.
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
            tabBarView
        }
    }

    var tabBarView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(Array(zip(self.tabItems.indices, self.tabItems)),
                        id: \.0, content: { index, name in
                    tabBarItem(string: name, tab: index)
                })
            }
            .padding(.horizontal)
        }
        .background(Color.white)
        .frame(height: 80)
        .edgesIgnoringSafeArea(.top)
    }

    var view1: some View {
        Color.red.opacity(0.2).edgesIgnoringSafeArea(.all)
    }

    var view2: some View {
        Color.blue.opacity(0.2).edgesIgnoringSafeArea(.all)
    }

    var view3: some View {
        Color.yellow.opacity(0.2).edgesIgnoringSafeArea(.all)
    }

    func tabBarItem(string: String, tab: Int) -> some View {
        Button {
            self.currentTab = tab
        } label : {
            VStack {
                Spacer()
                Text(string)
                    .font(.system(size: 13, weight: .light, design: .default))
                if self.currentTab == tab {
                    Color.black
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: currentTab)
        }
        .buttonStyle(.plain)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
