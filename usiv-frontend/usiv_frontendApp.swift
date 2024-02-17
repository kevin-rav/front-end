//
//  usiv_frontendApp.swift
//  usiv-frontend
//
//  Created by Kevin Ravakhah on 2/15/24.
//

import SwiftUI

@main
struct usiv_frontendApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = LoginViewModel()
            LoginView(viewModel: viewModel)
        }
    }
}
