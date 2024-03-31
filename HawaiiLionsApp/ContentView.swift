//
//  ContentView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 7/3/22.
//

import SwiftUI

struct ContentView: View {
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

struct ContactLoadCell: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var client: Client
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .frame(width: 60, height: 60)
            VStack(alignment: .leading) {
                Capsule()
                    .frame(height: 10)
                Capsule()
                    .frame(width: UIScreen.main.bounds.width / 3, height: 10)
            }
        }
        .opacity(isAnimating ? 0.5 : 1)
        .foregroundColor(colorScheme == .light ? Color.black.opacity(0.3) : Color.white.opacity(0.3))
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever()) {
                isAnimating = true
            }
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
