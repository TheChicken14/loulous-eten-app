//
//  ExtraNotesSheet.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 21/09/2021.
//

import SwiftUI

struct ExtraNotesSheet: View {
    @Binding var extraNotes: String
    var editing: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer(minLength: 10)
                        TextEditor(text: $extraNotes)
                            .padding()
                            .foregroundColor(editing ? .primary : .secondary)
                            .disabled(!editing)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 1)
                            )
                        
                        Spacer(minLength: 10)
                        
                    }
                    Spacer(minLength: 10)
                }
                
                if  extraNotes.isEmpty {
                    VStack(alignment: .leading) {
                        if editing {
                            Text("createPet.extraNotes")
                                .font(.custom("Helvetica", size: 24))
                                .opacity(0.25)
                                .multilineTextAlignment(.leading)
                        } else {
                            Text("Leeg...")
                                .font(.custom("Helvetica", size: 24))
                                .opacity(0.25)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }.navigationTitle("createPet.extraNotes").toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("general.close", systemImage: "xmark.circle")
                    }
                    
                }
            }
        }
    }
}

struct ExtraNotesSheet_Previews: PreviewProvider {
    static var previews: some View {
        ExtraNotesSheet(extraNotes: .constant(""), editing: true)
    }
}
