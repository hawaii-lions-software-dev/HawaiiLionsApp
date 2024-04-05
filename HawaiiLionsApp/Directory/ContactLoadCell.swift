//
//  SwiftUIView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 3/31/24.
//

import SwiftUI

struct ContactLoadCell: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var client: Client
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .frame(width: 60, height: 60)
            VStack(alignment: .leading) {
                Capsule()
                    .frame(height: 10)
                Capsule()
                    .frame(width: UIScreen.main.bounds.width / 3, height: 10)
            }
        }
        .opacity(isAnimating ? 0.5 : 1)
        .foregroundColor(colorScheme == .light ? Color.black.opacity(0.3) : Color.white.opacity(0.3))
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever()) {
                isAnimating = true
            }
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

#Preview {
    ContactLoadCell()
}
