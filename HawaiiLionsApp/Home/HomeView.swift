//
//  HomeView2.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 3/31/24.
//

import SwiftUI

class SelectedObject: ObservableObject {
    @Published var isShowing = false
    @Published var name = ""
}

struct HomeView2: View {
    @Namespace var animation
    @StateObject var selectedObject = SelectedObject()
    var body: some View {
        ZStack {
            if !selectedObject.isShowing {
                TodayView(animation: animation)
                                .environmentObject(selectedObject)
                                .zIndex(1.0)
            } else if selectedObject.isShowing{
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.white, Color.black)
                        .font(.system(size: 35)).padding()
                        .padding([.top],55)
                        .padding([.trailing],20)
                        .zIndex(3.0)
                        .opacity(selectedObject.isShowing ? 1 : 0.0)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
                                selectedObject.isShowing = false
                            }
                        }
                    TodayDetaiView(animation: animation)
                        .environmentObject(selectedObject)
                        .zIndex(2.0)
                    Color(.white)
                        .opacity(0.25)
                        .zIndex(1.5)
                }
            }
        }
    }
}
