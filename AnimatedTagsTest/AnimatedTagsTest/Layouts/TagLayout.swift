//
//  TagLayout.swift
//  AnimatedTagsTest
//
//  Created by Sam Greenhill on 8/13/23.
//

import SwiftUI

struct TagLayout: Layout {
    // Layout Properties
    var alignment: Alignment = .center
    //Both Horizontal and Vertical
    var spacing: CGFloat = 10

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        let rows = generateRows(maxWidth, proposal, subviews)

        for (index, row) in rows.enumerated() {
            // Finding max height in each row and adding it to the View's Total Height
            if index == (rows.count - 1) {
                // Since there is no spacing needed for the last item
                height += row.maxHeight(proposal)
            } else {
                height += row.maxHeight(proposal) + spacing
            }
        }
        return .init(width: maxWidth, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {

        // Placing Views
        var origin = bounds.origin
        let maxWidth = bounds.width
        let rows = generateRows(maxWidth, proposal, subviews)

        for row in rows {
            // Changing Origin X based on Alignment
            // subtract maxX with maxWidth so that any padding doesn't change whole view
            let leading: CGFloat = bounds.maxX - maxWidth
            // the origin for trailing can be easily calculated by subtracting the total row width from the maximum width. Since the trailing origin is found, its obvious that half of this value will lead to the center origin
            let trailing = bounds.maxX - (row.reduce(CGFloat.zero) { partialResult, view in
                let width = view.sizeThatFits(proposal).width

                if view == row.last {
                    // No Spacing
                    return partialResult + width
                }
                // With Spacing
                return partialResult + width + spacing
            })

            let center = (trailing + leading) / 2


            // Resetting Origin X to Zero for each row
            origin.x = (alignment == .leading ? leading : alignment == .trailing ? trailing : center)


            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                // Updating Origin X
                origin.x += (viewSize.width + spacing)
            }
            // Updating Origin Y
            origin.y += (row.maxHeight(proposal) + spacing)
        }
    }

    // Generating rows based on Available Size
    /// Since we're creating a list of rows, each of which is made up of a list of views for that row, what we are doing is straightforward: Whenever the row origin is wider than the screen, we'll start a new row and begin adding Views. This allows the grid column to be dynamically set based on the size of the content.
    func generateRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subviews: Subviews) -> [[LayoutSubviews.Element]] {
        var row: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []

        // Origin
        var origin = CGRect.zero.origin


        for view in subviews {
            let viewSize = view.sizeThatFits(proposal)

            // Pushing to New Row
            if (origin.x + viewSize.width + spacing) > maxWidth {
                rows.append(row)
                row.removeAll()
                // Resetting X Origin since it needs to start from left to right
                origin.x = 0
                row.append(view)
                // Updating Origin X
                origin.x += (viewSize.width + spacing)
            } else {
                // Adding item to same row
                row.append(view)
                // Updating Origin X
                origin.x += (viewSize.width + spacing)
            }
        }

        // Checking for any exhaust row
        if !row.isEmpty {
            rows.append(row)
            row.removeAll()
        }
        return rows
    }

}

extension [LayoutSubviews.Element] {
    func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
        return self.compactMap { view in
            return view.sizeThatFits(proposal).height
        }.max() ?? 0
    }
}

struct TagLayout_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
