//
//  GradientBackground.swift
//  GradientBackground
//
//  Created by Wisse Hes on 17/08/2021.
//

import SwiftUI

struct GradientBackground: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        switch colorScheme {
        case .light:
            LightModeBG()
        case .dark:
            DarkModeBG()
        default:
            LightModeBG()
        }
    }
}

struct LightModeBG: View {
    var body: some View {
        LinearGradient(colors: [.blue, .white], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
    }
}

struct DarkModeBG: View {
    var body: some View {
        LinearGradient(colors: [.blue, .black], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
    }
}

struct GradientBackground_Previews: PreviewProvider {
    static var previews: some View {
        GradientBackground()
    }
}
