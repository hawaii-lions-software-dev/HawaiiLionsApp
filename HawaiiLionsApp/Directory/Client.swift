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
    case updateError
}

class Client: ObservableObject {
    @Published var loadingStatus = LoadingStatus.loading
    
    init() {
        let fileName = UserDefaults.standard.string(forKey: "key") ?? "notFound"
        Task.init(operation: {
            await fetchData(url: "https://www.hawaiilions.org/"+fileName.lowercased()+".json")
        })
    }
    
    @Published var contacts: [Contact]?
    private var response: Response? {
        didSet {
            if response!.status == 200 {
                print(response!.message)
                contacts = response!.body!
                loadingStatus = .success
            } else if (response!.status == 201) {
                print(response!.message)
                contacts = response!.body!
                loadingStatus = .updateError
            } else {
                print(response!.message)
                loadingStatus = .error
            }
        }
    }
    
    func fetchData(url: String) async {
        DispatchQueue.main.async {
            self.loadingStatus = .loading
        }
//        guard let url = Bundle.main.url(forResource: "data.json", withExtension: nil) else { /* Used to fetch data from local file */
        guard let url = URL(string: url) else {  /* Used to fetch data from website */
            DispatchQueue.main.async {
                self.loadingStatus = .error
                self.fetchLocalData()
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
            let encoder = JSONEncoder()
            let saveToStorage = try encoder.encode(response)
            UserDefaults.standard.set(saveToStorage, forKey: "contacts")
        } catch {
            print("There was an error fetching or decoding the data")
            DispatchQueue.main.async {
                self.loadingStatus = .error
                self.fetchLocalData()
            }
            return
        }
    }
    
    func fetchLocalData() {
        if let data = UserDefaults.standard.data(forKey: "contacts") {
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.async {
                    self.response = response
                    self.response?.status = 201
                }
            } catch {
                print("Unable to Decode Note (\(error))")
            }
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
    var status: Int
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
