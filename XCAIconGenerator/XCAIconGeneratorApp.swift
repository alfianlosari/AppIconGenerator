//
//  XCAIconGeneratorApp.swift
//  XCAIconGenerator
//
//  Created by Alfian Losari on 19/03/22.
//

import SwiftUI

@main
struct XCAIconGeneratorApp: App {
    var body: some Scene {
        WindowGroup {
            #if targetEnvironment(macCatalyst)
            ContentView()
                .onAppear {
                    guard let scenes = UIApplication.shared.connectedScenes as? Set<UIWindowScene> else { return }
                    for window in scenes {
                        window.title = "XCA App Icon Generator"
                        guard let sizeRestrictions = window.sizeRestrictions else { continue }
                        sizeRestrictions.minimumSize = CGSize(width: 360, height: 600)
                        sizeRestrictions.maximumSize = sizeRestrictions.minimumSize
                    }
                }
            #else
            NavigationView {
                ContentView()
                    .navigationTitle("XCA App Icon Gen")
            }
            .navigationViewStyle(StackNavigationViewStyle())
            #endif
        }
    }
}
