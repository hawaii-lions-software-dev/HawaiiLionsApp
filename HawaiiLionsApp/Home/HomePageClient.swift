//
//  Client.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 7/3/22.
//

import Foundation
import SwiftUI

class HomePageClient: ObservableObject {
    @Published var loadingStatus = LoadingStatus.loading
    
    init() {
        Task.init(operation: {
            await fetchData(url: "https://hawaiilions.org/homepage.json")
        })
    }
    
    @Published var items: [FeaturedItem]?
    private var response: HomeResponse? {
        didSet {
            if response!.status == 200 {
                print(response!.message)
                items = response!.body!
                loadingStatus = .success
            } else if (response!.status == 201) {
                print(response!.message)
                items = response!.body!
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
            let response = try decoder.decode(HomeResponse.self, from: data)
            DispatchQueue.main.async {
                self.response = response
            }
            let encoder = JSONEncoder()
            let saveToStorage = try encoder.encode(response)
            UserDefaults.standard.set(saveToStorage, forKey: "home")
        } catch {
            print("There was an error fetching or decoding the home page content")
            DispatchQueue.main.async {
                self.loadingStatus = .error
                self.fetchLocalData()
            }
            return
        }
    }
    
    func fetchLocalData() {
        if let data = UserDefaults.standard.data(forKey: "home") {
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(HomeResponse.self, from: data)
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

struct TextContent: Codable, Hashable {
    let heading: String
    let text: String
}

struct FeaturedItem: Hashable, Codable {
    let title: String
    let subtitle: String
    let description: String
    let textContent: [TextContent]
}

struct HomeResponse: Codable {
    var status: Int
    let message: String
    let body: [FeaturedItem]?
}
