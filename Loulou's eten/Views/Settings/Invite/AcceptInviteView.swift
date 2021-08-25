//
//  AcceptInviteView.swift
//  AcceptInviteView
//
//  Created by Wisse Hes on 25/08/2021.
//

import SwiftUI
import UIKit

struct AcceptInviteView: View {
    
    var inviteCode: String
    @Binding var sheetShown: Bool
    
    @State var loading: Bool = true
    @State var error: Bool = false
    
    @State var inviteItem: InviteItem?
    
    @State var buttonState: ButtonState = .normal
    
    var body: some View {
        NavigationView {
            VStack {
                if loading {
                    ProgressView()
                } else {
                    if error {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text("invite.error")
                            .font(.headline)
                        Text("invite.tryAgain")
                            .font(.subheadline)
                    } else if let invite = inviteItem {
                        List {
                            HStack {
                                Text("invite.petName")
                                Spacer()
                                Text(invite.pet.name)
                            }
                            
                            HStack {
                                Text("invite.inviterName")
                                Spacer()
                                Text(invite.from.name)
                            }
                        }
                        
                        Button {
                            accept()
                        } label: {
                            ButtonLabel(
                                title: "invite.accept",
                                imageName: "checkmark",
                                color: .green,
                                state: buttonState
                            )
                        }
                    }
                }
            }.navigationBarTitle("invite").onAppear(perform: load).toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        self.sheetShown = false
                    } label: {
                        Label("general.close", systemImage: "xmark.circle")
                    }
                }
            }
        }
    }
    
    func load() {
        API.request("\(Config.API_URL)/invite/info/\(inviteCode)").validate().responseDecodable(of: InviteItem.self) { response in
            switch response.result {
            case .success(let invite):
                self.loading = false
                self.error = false
                self.inviteItem = invite
            case .failure(_):
                self.error = true
            }
        }
    }
    
    func accept() {
        buttonState = .loading
        
        API.request("\(Config.API_URL)/invite/accept/\(inviteCode)", method: .post).validate().response { response in
            switch response.result {
            case .success(_):
                buttonState = .success
                haptic()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    sheetShown = false
                }
            case .failure(_):
                buttonState = .success
            }
        }
    }
    
    func haptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

struct AcceptInviteView_Previews: PreviewProvider {
    static var previews: some View {
        AcceptInviteView(inviteCode: "vl-1y.YYD5", sheetShown: .constant(false))
    }
}
