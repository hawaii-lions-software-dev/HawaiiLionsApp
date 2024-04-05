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
            //            HomeView(recipie: recipieData[0])
            HomeView2()
                .tabItem {
                    Label("Menu", systemImage: "house")
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
