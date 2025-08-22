//
//  WhiteChristmasesApp.swift
//  WhiteChristmases
//
//  Created by Diana Dezso on 19/08/2025.
//

import SwiftUI

@main
struct WhiteChristmasesApp: App {
    @StateObject private var viewModel = AppStateViewModel()

    var body: some Scene {
        WindowGroup {
            if viewModel.didFinishLoading {
                ContentView()
            } else {
                WelcomeView(viewModel: viewModel)
            }
        }
    }
}
