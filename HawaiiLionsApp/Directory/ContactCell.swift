//
//  ContactListCellView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 3/31/24.
//

import SwiftUI

struct ContactCell: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var client: Client
    
    var contact: Contact
    
    var body: some View {
        HStack(spacing: 10) {
            if contact.image != nil {
                AsyncImage(url: URL(string: contact.image!)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(150)
                .shadow(radius: 3)
            } else {
                ZStack {
                    Circle()
                        .fill(Color.random())
                        .frame(width: 60, height: 60)
                    Text("\(String(contact.first.uppercased().prefix(1)))")
                        .font(.system(.title))
                        .foregroundColor(Color.white)
                }
            }
            VStack(alignment: .leading) {
                Text("\(contact.first) \(contact.last)")
                    .font(.system(.headline))
                Group {
                    Text(contact.title)
                        .font(.system(.caption))
                    Text(contact.club)
                        .font(.system(.caption))
                }
                .foregroundColor(colorScheme == .light ? Color.black.opacity(0.7) : Color.white.opacity(0.7))
            }
        }
    }
}

//#Preview {
//    ContactCell()
//}
