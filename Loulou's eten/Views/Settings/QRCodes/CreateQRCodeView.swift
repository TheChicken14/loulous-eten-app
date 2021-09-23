//
//  CreateQRCodeView.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 23/09/2021.
//

import SwiftUI

struct CreateQRCodeView: View {
    
    @StateObject var viewModel = CreateQRCodeViewModel()
    @Environment(\.dismiss) var dismiss
    
    var form: some View {
        Form {
            
            explanation
            
            HStack {
                Picker("home.pet", selection: $viewModel.selectedPetIndex) {
                    ForEach(0..<viewModel.pets.count, id: \.self) { i in
                        Text(viewModel.pets[i].name)
                    }
                }//.pickerStyle(.menu)
            }
            
            doneButton
        }
    }
    
    var doneButton: some View {
        HStack {
            Spacer()
            
            Button {
                viewModel.createQRCode()
            } label: {
                switch viewModel.savingState {
                case .normal:
                    Label("general.save", systemImage: "checkmark")
                case .loading:
                    ProgressView()
                case .success:
                    Label("general.success", systemImage: "checkmark.circle")
                        .labelStyle(.iconOnly)
                }
            }.disabled(viewModel.savingState == .loading)
            
            Spacer()
        }
    }
    
    var explanation: some View {
        Text("qrcode.create.explanation")
            .fixedSize(horizontal: false, vertical: true)
            .font(.subheadline)
            .padding(.vertical)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.loading {
                    ProgressView()
                } else {
                    form
                }
            }.navigationTitle("qrcode.create")
                .onAppear(perform: viewModel.load)
                .onReceive(viewModel.viewDismissalModePublisher) { output in
                    if output {
                        dismiss()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Label("general.close", systemImage: "xmark.circle")
                        }
                    }
                }
        }
    }
}

struct CreateQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateQRCodeView()
    }
}
