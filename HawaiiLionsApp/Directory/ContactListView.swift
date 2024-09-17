//
//  ContentView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 7/3/22.
//

import SwiftUI

struct ContactListView: View {
    @StateObject var fetchContactService = Client()
    @AppStorage("key") var key = ""
    @State private var search = ""

    var body: some View {
        NavigationView {
            List {
                switch fetchContactService.loadingStatus {
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
                case .updateError:
                    Text("Error, Could not get latest updates from the server. We will display outdated information. This may mean you are not connected to the internet. If this issue persists, please contact informationtechnology@hawaiilions.org")
                    ForEach(searchResults, id: \.email) { contact in
                        NavigationLink(destination: DetailView(contact: contact)) {
                            ContactCell(contact: contact)
                        }
                    }
                    
                case .error:
                    Text("Error, Most times this means the key is invalid. Please tap on the gear on the top right to input a new key. If this issue persists, please contact informationtechnology@hawaiilions.org")
                }
            }
            .navigationTitle("D50 Directory")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        alertTF(title: "Please enter the key", message: "Email informationtechnology@hawaiilions.org for a key", hintText: "Key", primaryTitle: "Ok", secondaryTitle: "Cancel") { text in
                            UserDefaults.standard.set(text, forKey: "key")
                            Task {
                                let fileName = UserDefaults.standard.string(forKey: "key") ?? "notFound"
                                await fetchContactService.fetchData(url: "https://www.hawaiilions.org/"+fileName.lowercased()+".json")
                            }
                        } secondaryAction: {}
                    }) {
                        Image(systemName: "gearshape")
                        .padding(10)
                    }
                }
            }
            .refreshable {
                let fileName = UserDefaults.standard.string(forKey: "key") ?? "notFound"
                await fetchContactService.fetchData(url: "https://www.hawaiilions.org/"+fileName.lowercased()+".json")
            }
            .searchable(text: $search)
        }
        .environmentObject(fetchContactService)
    }
    
    var searchResults: [Contact] {
        if fetchContactService.contacts == nil {
            return []
        } else if search.isEmpty {
            return fetchContactService.contacts!
        } else {
            return fetchContactService.contacts!.filter {
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
