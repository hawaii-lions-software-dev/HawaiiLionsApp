//
//  CardView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 3/31/24.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var selectedObject: SelectedObject
    var animation: Namespace.ID
    var itemName: String
    let itemHeight:CGFloat = 500
    let SVWidth = UIScreen.main.bounds.width - 40
    
    var body: some View {
        ZStack {
            Image(itemName)
                .resizable()
                .scaledToFill()
                .frame(width:self.SVWidth, height: self.itemHeight)
                .clipped()
                .background(Color.white)
                .matchedGeometryEffect(id: itemName + "image", in: animation)
            
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text("Subtitle")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(.init(white: 0.8)).opacity(0.6)
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                        Text("\(itemName)")
                            .font(.system(size: 36, weight: .bold, design: .default))
                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                            .matchedGeometryEffect(id: itemName + "text", in: animation)
                    }.padding()
                    Spacer()
                }
                Spacer()
                HStack{
                    VStack(alignment: .leading){
                        Text("Description")
                            .lineLimit(2)
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                            .foregroundColor(.init(white: 0.9)).opacity(0.8)
                            .matchedGeometryEffect(id: itemName + "description", in: animation)
                    }.padding()
                    Spacer()
                }
            }.frame(width: self.SVWidth)
        }
        .cornerRadius(15).foregroundColor(.white)
        .shadow(color: .init(red: 0.1, green: 0.1, blue: 0.1)
                , radius: 11 , x: 0, y: 4)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        return CardView(animation: Namespace().wrappedValue, itemName: "PBJ Sand")
    }
}
