//
//  ContentView.swift
//  email sender
//
//  Created by Krzysztof Czura on 23/12/2023.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    @State private var isShowingMailView = false
    @State private var unableToSend = false

    var body: some View {
        VStack {
            Button(action: {
                if MFMailComposeViewController.canSendMail() {
                    self.isShowingMailView.toggle()
                } else {
                    // Obsłuż sytuację, gdy użytkownik nie może wysłać e-maila (np. brak skonfigurowanego konta e-mailowego)
                    unableToSend = true
                }
            }) {
                Text("Zgłoś problem")
            }
            .alert("Error", isPresented: $unableToSend, actions: {
                Button("OK") {
                    unableToSend = false
                    if let mailURL = URL(string: "message://") {
                        if UIApplication.shared.canOpenURL(mailURL) {
                            UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
                        } else {
                            print("Aplikacja Poczta nie jest dostępna.")
                        }
                    }
                }
            }, message: {
                Text("An issue occurred while attempting to submit the report. Please try configuring your email account.")
            })
            .sheet(isPresented: $isShowingMailView) {
                MailView(isShowing: self.$isShowingMailView)
            }
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
