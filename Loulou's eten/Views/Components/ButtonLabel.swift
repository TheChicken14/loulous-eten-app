//
//  ButtonLabel.swift
//  ButtonLabel
//
//  Created by Wisse Hes on 16/08/2021.
//

import SwiftUI

struct ButtonLabel: View {
    var title: String
    var imageName: String
    var color: Color
    var state: ButtonState?
    
    var body: some View {
        if let state = state {
            switch state {
            case .normal:
                Label(LocalizedStringKey(title), systemImage: imageName)
                    .frame(width: 280, height: 50)
                    .background(color)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding()
            case .loading:
                ProgressView()
                    .frame(width: 280, height: 50)
                    .background(color)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding()
            case .success:
                Image(systemName: "checkmark.circle")
                    .frame(width: 280, height: 50)
                    .background(color)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding()
            }
        } else {
        Label(LocalizedStringKey(title), systemImage: imageName)
            .frame(width: 280, height: 50)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding()
        }
    }
}

struct ButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            print("hey")
        } label: {
            ButtonLabel(title: "general.done", imageName: "checkmark", color: .blue)
        }
    }
}
