//
//  ContentView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 7/3/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var client = Client()
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Menu", systemImage: "house")
                }
            ConstitutionBylawsView()
                .tabItem{
                    Label("Const/Bylaws", systemImage: "newspaper")
                }
            ContactListView()
                .tabItem{
                    Label("Directory", systemImage: "list.dash")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
