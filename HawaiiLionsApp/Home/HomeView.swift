//
//  HomeView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 3/31/24.
//

import SwiftUI

class SelectedObject: ObservableObject {
    @Published var isShowing = false
    @Published var title = ""
    @Published var subtitle = ""
    @Published var description = ""
    @Published var textContent = [TextContent(heading: "Lionism", text: "The International Association of Lions Clubs started as a dream in the mind of a young Chicago insurance agent. The man was Melvin Jones; the dream was the consolidation of several independent clubs, already in existence, into one strong, influential unit for service to humanity. This dream was presented to the leaders of various independent groups at a meeting in Chicago, Illinois, on June 7, 1917. From that meeting came a call for the Associationâ€™s annual convention, which was held October 8-10, 1917 in Dallas, Texas, with 23 clubs partic- ipating. Thus was conceived and founded the worldâ€™s largest, most active and most representative service club organization The Association did not become international in fact until 1920 when the first Lions clubs were organized in Canada. The third, fourth and fifth Lions countries were China, Mexico and Cuba in 1926 and 1927. Eight years later Central America entered the fold, and in 1936 the first South American club was established in Colombia. The first Lions club in Europe was organized in Stockholm, Sweden on March 24, 1948. Although the largest by far, the Lions are the youngest of the major service club organizations. Today our Association is in practically all countries of the world. On every continent it is working through hundreds of thousands of Lions of all nationalities and creeds. The Lions believe in club meetings where good fellowship and harmony prevail; in developing projects and activities geared to the needs of their communities; in broad participa- tion in an international program of brotherhood and fellowship, based upon service wherever the need exists; in service to humanity without thought to race, creed, nationality, religion or politics; in the ultimate leadership of Lionism, but not at the expense of or in conflict with the programs of other organiza- tions which, with different methods, seek the same goal of unselfish service to mankind.")]
}

struct HomeView: View {
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
                    TodayDetailView(animation: animation)
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
