//
//  HowToAcceptInvite.swift
//  HowToAcceptInvite
//
//  Created by Wisse Hes on 25/08/2021.
//

import SwiftUI

struct HowToAcceptInvite: View {
    var body: some View {
        VStack {
            List {
                Text("Vraag degene die al een huisdier heeft toegevoegd om het volgende te doen:")
                
                Text("1. Open de app")
                Text("2. Tik op het instellingen icoontje rechtsbovenin.")
                Text("3. Tik op \"Uitnodigingen\" > Het plus (+) icoontje rechtsbovenin.")
                Text("4. Selecteer het huisdier waarvoor je een uitnodiging wilt maken.")
                Text("5. Tik op \"Klaar\".")
                Text("6. Tik op de uitnodiging die is gemaakt.")
                Text("7. Scan de QR-Code met deze telefoon.")
                Text("8. Klaar!")
                
            }.lineLimit(nil)
        }.navigationTitle("howtoinvite.header")
    }
}

struct HowToAcceptInvite_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HowToAcceptInvite()
        }
    }
}
