//
//  Client.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 7/3/22.
//

import Foundation
import SwiftUI

enum LoadingStatus {
    case loading
    case success
    case error
}

class Client: ObservableObject {
    @Published var contacts: [Contact]?
    @Published var wpContent: [WpContent]?
    @Published var loadingStatus = LoadingStatus.loading
    @Published var loadingStatus2 = LoadingStatus.loading

    init() {
        Task.init(operation: {
            await fetchContactData()
            await fetchWpContentResponse()
        })
    }
    
    private var contactResponse: Response? {
        didSet {
            if contactResponse!.status == 200 {
                print(contactResponse!.message)
                contacts = contactResponse!.body!
                loadingStatus = .success
            } else {
                print(contactResponse!.message)
                loadingStatus = .error
            }
        }
    }
    
    private var wpContentResponse: Response2? {
        didSet {
//            if wpContentResponse!.status == 200 {
//                print(wpContentResponse!.message)
                wpContent = wpContentResponse!.body!
                loadingStatus = .success
//                print(wpContent)
//            } else {
//                print(wpContentResponse!.message)
//                loadingStatus = .error
//            }
        }
    }
    
    func fetchContactData() async {
        DispatchQueue.main.async {
            self.loadingStatus = .loading
        }
//        guard let url = Bundle.main.url(forResource: "data.json", withExtension: nil) else { /* Used to fetch data from local file */
        let fileName = UserDefaults.standard.string(forKey: "key") ?? "notFound"
        guard let url = URL(string: "https://www.hawaiilions.org/"+fileName.lowercased()+".json") else {  /* Used to fetch data from website */
            DispatchQueue.main.async {
                self.loadingStatus = .error
            }
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(Response.self, from: data)
            DispatchQueue.main.async {
                self.contactResponse = response
            }
        } catch {
            print("There was an error fetching or decoding the data")
            DispatchQueue.main.async {
                self.loadingStatus = .error
            }
            return
        }
    }
    
    func fetchWpContentResponse() async {
        DispatchQueue.main.async {
            self.loadingStatus2 = .loading
        }
//        guard let url = Bundle.main.url(forResource: "data.json", withExtension: nil) else { /* Used to fetch data from local file */
        guard let url = URL(string: "https://hawaiilions.org/wp-json/wp/v2/posts") else {  /* Used to fetch data from website */
            DispatchQueue.main.async {
                self.loadingStatus2 = .error
            }
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(Response2.self, from: data)
            DispatchQueue.main.async {
                self.wpContentResponse = response
            }
        } catch {
            print("There was an error fetching or decoding the data")
            DispatchQueue.main.async {
                self.loadingStatus2 = .error
            }
            return
        }
    }
    
    
}

struct Contact: Codable {
    var first: String
    var last: String
    var email: String
    var phone: String
    var title: String
    var image: String?
    var club: String
}

struct Response: Codable {
    let status: Int
    let message: String
    let body: [Contact]?
}

struct WpContent: Codable {
    var id: String
    var title: Content
    var content: Content
}

struct Content: Codable {
    var rendered: String
}

struct Response2: Codable {
    let body: [WpContent]?
}

extension Color {
    static func random() -> Color {
        return Color(
            red:   .random(in: 0..<1),
           green: .random(in: 0..<1),
           blue:  .random(in: 0..<1)
        )
    }
}
