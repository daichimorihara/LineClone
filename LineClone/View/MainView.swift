//
//  MainView.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/18.
//

import SwiftUI


struct MainView: View {
    @StateObject var vm = MainViewModel()
    
    
    var body: some View {
        NavigationView {
            VStack {
                //customNavigationBar
                // searchBar

                ScrollView {
                    ForEach(1...20, id: \.self) { idx in
                        Text("User")
                        Divider()
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationTitle("Chats")
        }
    }

}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
