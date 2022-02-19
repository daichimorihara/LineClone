//
//  ContentView.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FriendView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            MainView()
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
