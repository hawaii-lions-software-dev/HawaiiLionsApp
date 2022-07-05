//
//  DetailView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 7/3/22.
//

import SwiftUI

struct DetailView: View {

    let contact: Contact
    
    var body: some View {
        VStack {
            if contact.image != nil {
                AsyncImage(url: URL(string: contact.image!)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(150)
                .shadow(radius: 3)
            } else {
                ZStack {
                    Circle()
                        .fill(Color.random())
                        .frame(width: 150, height: 150)
                    Text("\(String(contact.first.uppercased().prefix(1)))")
                        .font(.system(.title))
                        .foregroundColor(Color.white)
                }
            }
            HStack {
                Text(contact.first)
                    .font(.title)
                    .fontWeight(.medium)
                Text(contact.last)
                    .font(.title)
                    .fontWeight(.medium)
            }
            HStack {
                Text(contact.title)
                    .foregroundColor(.gray)
                    .font(.callout)
            }
            HStack {
                Text(contact.club)
                    .foregroundColor(.gray)
                    .font(.callout)
            }
            Form {
                HStack {
                    Text("Phone")
                    Spacer()
                    Text(contact.phone)
                        .foregroundColor(.gray)
                        .font(.callout)
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text(contact.email)
                        .foregroundColor(.gray)
                        .font(.callout)
                }
//                HStack {
//                    Text("Address")
//                    Spacer()
//                    Text(contact.address)
//                        .foregroundColor(.gray)
//                        .font(.callout)
//                        .frame(width: 180)
//                }
                Section {
                    Button(action: {
                        let phone = "mailto:"
                        let phoneNumberformatted = phone + contact.email
                            guard let url = URL(string: phoneNumberformatted) else { return }
                                    UIApplication.shared.open(url)
                    }) {
                        Text("Email "+contact.first)
                        .foregroundColor(.blue)
                    }
                    Button(action: {
                        callNumber(phoneNumber: contact.phone)
                    }) {
                        Text("Call "+contact.first)
                        .foregroundColor(.blue)
                    }
                }
            }
        }
    }
    
    private func callNumber(phoneNumber:String) {
        let formattedPhoneNumber = phoneNumber
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
      if let phoneCallURL = URL(string: "tel://\(formattedPhoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
    
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(contact: contacts[0])
//    }
//}
