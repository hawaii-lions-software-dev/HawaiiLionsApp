//
//  TodayView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 3/31/24.
//

import SwiftUI

struct TodayView: View {
    var animation: Namespace.ID
    static let itemArray = ["Breakfast", "ChxSalad", "ClamChow", "PBJ Sand", "WadaChicken"]
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    Text("WEDNESDAY, JANUARY 1")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(.gray)
                    Text("Aloha").font(.system(size: 40, weight: .bold, design: .default))
                }
                Spacer()
            }
            .padding(.leading)
            .padding(.top)
            .padding(.trailing)
            LazyVGrid(columns: [GridItem()], content: {
                ForEach(TodayView.itemArray, id: \.self) { item in
                    CardView(animation: animation, itemName: item)
                        .padding([.bottom], 15)
                }
            })
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedObject = SelectedObject()
        selectedObject.name = "PBJ Sand"
        selectedObject.isShowing = true

        return TodayView(animation: Namespace().wrappedValue)
            .environmentObject(selectedObject)
    }
}
