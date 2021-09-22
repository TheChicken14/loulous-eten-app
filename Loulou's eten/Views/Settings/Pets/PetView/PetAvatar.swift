//
//  PetAvatar.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 22/09/2021.
//

import SwiftUI

struct PetAvatar: View {
    var pet: Pet?
    
    var body: some View {
        if let picName = pet?.profile?.pictureName {
            AsyncImage(url: URL(string: "\(Config.API_URL)/image/get/\(picName)")!) { phase in
                switch phase {
                case .success(let image):
                    ImageContainer {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 125, height: 125)
                    }
                case .empty:
                    ImageContainer {
                        ProgressView()
                    }
                case .failure(_):
                    ImageContainer {
                        ProgressView()
                    }
                @unknown default:
                    ImageContainer {
                        ProgressView()
                    }
                }
            }
        } else {
            Image(systemName: "photo")
                .font(.system(size: 40.0))
                .scaledToFit()
                .frame(width: 125, height: 125)
                .overlay(
                    Circle()
                        .stroke(.gray, lineWidth: 2.5)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                )
                .padding()
        }
    }
}

struct ImageContainer<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .clipShape(Circle())
            .frame(width: 125, height: 125)
            .overlay(
                Circle()
                    .stroke(.gray, lineWidth: 2.5)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            )
            .padding()
    }
}

struct PetAvatar_Previews: PreviewProvider {
    static var previews: some View {
        PetAvatar(pet: Pet(name: "Loulou", id: 1, profile: PetProfile(id: 1, petId: 1, pictureName: "petPhoto-1632325110521-31212938.jpg", birthday: "", morningFood: "", dinnerFood: "", extraNotes: ""), owners: []))
    }
}
