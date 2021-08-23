//
//  FeedingSheet.swift
//  FeedingSheet
//
//  Created by Wisse Hes on 17/08/2021.
//

import SwiftUI

struct FeedingSheet: View {
    
    var pet: Pet
    @StateObject var viewModel = FeedingViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                List {
                    DatePicker(
                        selection: $viewModel.date,
                        displayedComponents: [.hourAndMinute],
                        label: { Label("general.time", systemImage: "calendar.badge.clock") }
                    ).font(Font.body.bold())
                    
                    HStack {
                        Label("feeding.type", systemImage: "leaf")
                            .font(Font.body.bold())
                        Spacer()
                        Picker("feeding.type", selection: $viewModel.feedingType) {
                            Text("feeding.type.morning").tag(FeedingType.morning)
                            Text("feeding.type.evening").tag(FeedingType.evening)
                        }.pickerStyle(MenuPickerStyle())
                    }
                    
//                    HStack {
//                        Label("feeding.by", systemImage: "person.fill")
//                            .font(Font.body.bold())
//                        Spacer()
//                        TextField("general.name", text: $viewModel.byName)
//                            .multilineTextAlignment(.trailing)
//                    }
                }
                
                Button {
                    viewModel.feed(pet: pet)
                } label: {
                    ButtonLabel(title: "general.done", imageName: "checkmark.circle", color: .green, state: viewModel.buttonState)
                    
                }.buttonStyle(PlainButtonStyle())
                
            }.navigationTitle("feeding.name")
                .navigationViewStyle(.stack)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Label("general.close", systemImage: "xmark.circle")
                        }
                    }
                }
                .onReceive(viewModel.viewDismissalModePublisher) { shouldDismiss in
                    if shouldDismiss {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        }
    }
}

struct FeedingSheet_Previews: PreviewProvider {
    static var previews: some View {
        FeedingSheet(pet: Pet(name: "loulou", id: 1))
    }
}
