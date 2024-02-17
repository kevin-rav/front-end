//
//  BackgroundView.swift
//  usiv-frontend
//
//  Created by Kevin Ravakhah on 2/16/24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Color(red: 186/255, green: 12/255, blue: 47/255)
                    .frame(maxWidth: .infinity)
                
                Color(red: 167/255, green: 177/255, blue: 178/255)
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 1000)
            .background(Color(red: 77/255, green: 77/255, blue: 77/255))
            .edgesIgnoringSafeArea(.vertical)
        }
    }
}
