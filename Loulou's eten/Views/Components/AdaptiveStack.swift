//
//  AdaptiveStack.swift
//  AdaptiveStack
//
//  Created by Wisse Hes on 22/08/2021.
//
// From https://www.hackingwithswift.com/quick-start/swiftui/how-to-automatically-switch-between-hstack-and-vstack-based-on-size-class

import SwiftUI

struct AdaptiveStack<Content: View>: View {
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content

    init(horizontalAlignment: HorizontalAlignment = .center, verticalAlignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        
        GeometryReader { proxy in
            if proxy.size.width < proxy.size.height {
                VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
            } else {
                HStack(alignment: verticalAlignment, spacing: spacing, content: content)
            }
        }
        
//        Group {
//            if sizeClass == .compact {
//                VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
//            } else {
//                HStack(alignment: verticalAlignment, spacing: spacing, content: content)
//            }
//        }
    }
}

struct AdaptiveStack_Previews: PreviewProvider {
    static var previews: some View {
        AdaptiveStack {
            Text("hey")
            Text("hey")
            Text("hey")
        }
    }
}
