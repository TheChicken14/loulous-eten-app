//
//  AboutView.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 27/09/2021.
//

import SwiftUI
import BetterSafariView

enum AboutViewAppURL: String {
    case privacyPolicy = "https://loulous-app.wissehes.nl/privacy"
    case website = "https://loulous-app.wissehes.nl"
}

struct AboutView: View {
    
    @State private var selectedURL: URL?
    
    var body: some View {
        List {
            VStack {
                HStack {
                    Spacer()
                    Image("loulou")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                    Spacer()
                }
                
                Text("about.loulousapp")
                    .font(.title)
                Text("about.subheader")
                    .font(.subheadline)
            }.padding()
            
            Button("about.website") {
                selectedURL = URL(string: AboutViewAppURL.website.rawValue)!
            }
        
            Button("about.privacyPolicy") {
                selectedURL = URL(string: AboutViewAppURL.privacyPolicy.rawValue)!
            }
            
            Link("about.contact", destination: URL(string: "mailto:\(Config.email)")!)
        }.navigationTitle("aboutThisApp")
            .safariView(item: $selectedURL) { url in
                SafariView(
                    url: url,
                    configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                    )
                )
            }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
