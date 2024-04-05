//
//  DetailView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 7/3/22.
//

import SwiftUI
import Contacts

struct DetailView: View {

    let contact: Contact
    
    enum AlertType: Identifiable {
            case first, second
            
            var id: Int {
                hashValue
            }
        }
    
    @State var alertType: AlertType?
    
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
                        .textSelection(.enabled)
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text(contact.email)
                        .foregroundColor(.gray)
                        .font(.callout)
                        .textSelection(.enabled)
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
                        phoneNumAction(phoneNumber: contact.phone, action: "tel://")
                    }) {
                        Text("Call "+contact.first)
                        .foregroundColor(.blue)
                    }
                    Button(action: {
                        phoneNumAction(phoneNumber: contact.phone, action: "sms://")
                    }) {
                        Text("Send a Message to "+contact.first)
                        .foregroundColor(.blue)
                    }
                    Button(action: {
                        saveContact(first: contact.first, last: contact.last, email: contact.email, phone: contact.phone, title: contact.title, club: contact.club)
                    }) {
                        Text("Add Contact for "+contact.first)
                        .foregroundColor(.blue)
                    }
                    .alert(item: $alertType) { type in
                        switch type {
                        case .first:
                            return Alert(title: Text("Successfully Added Contact"))
                        case .second:
                            return Alert(title: Text("Failure to add Contact"))
                        }
                    }
                }
            }
        }
    }
    
    private func phoneNumAction(phoneNumber:String, action:String) {
        let formattedPhoneNumber = phoneNumber
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
      if let phoneNumberURL = URL(string: "\(action)://\(formattedPhoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneNumberURL)) {
            application.open(phoneNumberURL, options: [:], completionHandler: nil)
        }
      }
    }

    
    private func saveContact(first: String, last: String, email: String, phone: String, title: String, club: String) {
        // Create a mutable object to add to the contact.
        let contact = CNMutableContact()
        contact.givenName = first
        contact.familyName = last
        let workEmail = CNLabeledValue(label: CNLabelWork, value: email as NSString)
        contact.emailAddresses = [workEmail]
        contact.phoneNumbers = [CNLabeledValue(
            label: CNLabelPhoneNumberiPhone,
            value: CNPhoneNumber(stringValue: phone))]
        contact.jobTitle = title
        contact.departmentName = club
        contact.organizationName = "D50 Lions"

        // Save the newly created contact.
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)

        do {
            try store.execute(saveRequest)
            alertType = .first
        } catch {
            print("Saving contact failed, error: \(error)")
            alertType = .second
            // Handle the error.
        }
    }
    
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(contact: contactPreview)
//    }
//}
