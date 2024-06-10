//
//  ContentView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 7/3/22.
//

import SwiftUI

struct ContactListView: View {
    @StateObject var client = Client()
    @AppStorage("key") var key = ""
    
    @State private var search = ""

    var body: some View {
        NavigationView {
            List {
                switch client.loadingStatus {
                case .loading:
                    ForEach(0..<25) { item in
                        ContactLoadCell()
                    }
                case .success:
                    ForEach(searchResults, id: \.email) { contact in
                        NavigationLink(destination: DetailView(contact: contact)) {
                            ContactCell(contact: contact)
                        }
                    }
                case .error:
                    Text("Error, Most times this means the key is invalid. Please tap on the gear on the top right to input a new key. If this issue persists, please contact kobeyarai@hawaiilions.org")
                }
            }
            .navigationTitle("D50 Directory")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        alertTF(title: "Please enter the key", message: "Email kobeyarai@hawaiilions.org for a key", hintText: "Key", primaryTitle: "Ok", secondaryTitle: "Cancel") { text in
                            UserDefaults.standard.set(text, forKey: "key")
                            Task {
                                await client.fetchData()
                            }
                        } secondaryAction: {}
                    }) {
                        Image(systemName: "gearshape")
                        .padding(10)
                    }
                }
            }
            .refreshable {
                await client.fetchData()
            }
            .searchable(text: $search)
        }
        .environmentObject(client)
    }
    
    var searchResults: [Contact] {
        if client.contacts == nil {
            return []
        } else if search.isEmpty {
            return client.contacts!
        } else {
            return client.contacts!.filter {
                $0.email.lowercased().contains(search.lowercased()) ||
                $0.phone.lowercased().contains(search.lowercased()) ||
                $0.first.lowercased().contains(search.lowercased()) ||
                $0.last.lowercased().contains(search.lowercased()) ||
                $0.title.lowercased().contains(search.lowercased()) ||
                $0.club.lowercased().contains(search.lowercased())
            }
        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
}

extension View {
    func alertTF(title: String, message: String, hintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (String)->(), secondaryAction: @escaping ()->() ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let key = UserDefaults.standard.string(forKey: "key")
        alert.addTextField { field in
            field.placeholder = hintText
            field.text = key
        }
        alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: { _ in
            secondaryAction()
        }))
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            }
            else {
                primaryAction("")
            }
        }))
        rootController().present(alert, animated: true, completion: nil)
    }
    
    func rootController()->UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
