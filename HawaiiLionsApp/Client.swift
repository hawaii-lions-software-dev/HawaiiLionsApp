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
    @Published var loadingStatus = LoadingStatus.loading
    
    init() {
        Task.init(operation: {
            await fetchData()
        })
    }
    
    @Published var contacts: [Contact]?
    private var response: Response? {
        didSet {
            if response!.status == 200 {
                print(response!.message)
                contacts = response!.body!
                loadingStatus = .success
            } else {
                print(response!.message)
                loadingStatus = .error
            }
        }
    }
    
    func fetchData() async {
        DispatchQueue.main.async {
            self.loadingStatus = .loading
        }
        // url that will wait 2 seconds to return
        let request = URLRequest(url: URL(string: "https://httpbin.org/delay/2")!)
        let _ = try! await URLSession.shared.data(for: request)
        // get the data from the file
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
                self.response = response
            }
        } catch {
            print("There was an error fetching or decoding the data")
            DispatchQueue.main.async {
                self.loadingStatus = .error
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

extension Color {
    static func random() -> Color {
        return Color(
            red:   .random(in: 0..<1),
           green: .random(in: 0..<1),
           blue:  .random(in: 0..<1)
        )
    }
}
