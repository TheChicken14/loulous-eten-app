//
//  GradientBackground.swift
//  GradientBackground
//
//  Created by Wisse Hes on 17/08/2021.
//

import SwiftUI

struct GradientBackground: View {
    
    @Environment(\.colorScheme) var colorScheme
    let color: Color = Color.purple
    
    var body: some View {
        switch colorScheme {
        case .light:
            LightModeBG(themeColor: color)
        case .dark:
            DarkModeBG(themeColor: color)
        default:
            LightModeBG(themeColor: color)
        }
    }
}

struct LightModeBG: View {
    let themeColor: Color
    
    var body: some View {
        LinearGradient(colors: [themeColor, .white], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
    }
}

struct DarkModeBG: View {
    let themeColor: Color

    var body: some View {
        LinearGradient(colors: [themeColor, .black], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
    }
}

struct GradientBackground_Previews: PreviewProvider {
    static var previews: some View {
        GradientBackground()
    }
}
