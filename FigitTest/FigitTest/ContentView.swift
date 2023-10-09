//
//  ContentView.swift
//  FigitTest
//
//  Created by Sam Greenhill on 4/25/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            FidgetTextView("Happy Birthday!", fontSize: 45)
        }
    }
}

extension ContentView {
    private func BackgroundView() -> some View {
        Color.primary.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
