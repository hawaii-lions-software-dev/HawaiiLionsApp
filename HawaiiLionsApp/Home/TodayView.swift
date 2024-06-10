//
//  TodayView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 3/31/24.
//

import SwiftUI

struct TodayView: View {
    @EnvironmentObject var selectedObject: SelectedObject
    var animation: Namespace.ID
    static let itemArray = ["Breakfast", "ChxSalad", "ClamChow","PBJ Sand","WadaChicken"]
    var body: some View {
//        VStack {
//            HStack {
//                VStack(alignment: .leading) {
//                    Text("WEDNESDAY, JANUARY 1")
//                        .font(.system(size: 18, weight: .bold, design: .default))
//                        .foregroundColor(.gray)
//                    Text("Aloha").font(.system(size: 40, weight: .bold, design: .default)).foregroundColor(.black)
//                }
//                Spacer()
//                //                Image(systemName: "ellipsis.circle.fill").font(.system(size: 25, weight: .bold, design: .default))
//            }
//            .padding(.leading)
//            .padding(.top)
//            .padding(.trailing)
            ScrollView {
//                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("WEDNESDAY, JANUARY 1")
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .foregroundColor(.gray)
                            Text("Aloha").font(.system(size: 40, weight: .bold, design: .default))
                        }
                        Spacer()
                        //                Image(systemName: "ellipsis.circle.fill").font(.system(size: 25, weight: .bold, design: .default))
                    }
                    .padding(.leading)
                    .padding(.top)
                    .padding(.trailing)
                    LazyVGrid(columns: [GridItem()], content: {
                        ForEach(TodayView.itemArray, id:\.self) {item in
                            if (!selectedObject.isShowing) {
                                CardView(animation: animation, itemName: item)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                            selectedObject.name = item
                                            selectedObject.isShowing = true
                                        }
                                    }
                                    .padding([.bottom],15)
                            }
                        }
                    })
//                }
            }
//        }
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
