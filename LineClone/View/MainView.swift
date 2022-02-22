//
//  MainView.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/18.
//

import SwiftUI
import SDWebImageSwiftUI


struct MainView: View {
    @StateObject var vm = MainViewModel()
    @State private var user: User?
    @State private var isShowingChatLog = false
    
    var body: some View {
        NavigationView {
            VStack {
                //customNavigationBar
                // searchBar
                customNavigationBar
                
                ScrollView {
                    ForEach(vm.recentMessages) { rm in
                        mainBody(recent: rm)
                        Divider()
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationTitle("Chats")
            .fullScreenCover(isPresented: $isShowingChatLog) {
                ChatLogView(user: self.user)
            }
        }
        
    }
    
    var customNavigationBar: some View {
        HStack {
            Text("Chats")
                .font(.system(size: 24, weight: .bold))
            
            Spacer()
        }
        .padding()
    }

    func mainBody(recent: RecentMessage) -> some View {
        Button {
            let uid = FirebaseManager.shared.auth.currentUser?.uid == recent.fromId ? recent.toId : recent.fromId
            
            self.user = User(id: uid, email: recent.email, profileImageUrl: recent.profileImageUrl)
            
            
            isShowingChatLog = true
        } label: {
            HStack(spacing: 16) {
                WebImage(url: recent.profileImageUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(50)
                
                VStack(alignment: .leading) {
                    Text(recent.username)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                    Text(recent.text)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
            
                Spacer()
                
                Text(recent.time)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
