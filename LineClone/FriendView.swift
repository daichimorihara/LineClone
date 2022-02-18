//
//  FriendView.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/18.
//

import SwiftUI
import SDWebImageSwiftUI

struct FriendView: View {
    @StateObject var vm = FriendViewModel()
    @State private var isShowingLogOut = false
    @State private var isSearching = false
    @State private var searchText = ""
    
    
    var body: some View {
        NavigationView {
            VStack {
                settingBar
                customNavigationBar
                //searchFunction
                SearchView(searchText: $searchText, isSearching: $isSearching)
                
                HStack {
                    Text("Friends lists")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                }
                .padding(.horizontal)
               
                ScrollView {
                    friendsLists
                }
            }
            
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $vm.isCurrentlyLoggedOut) {
                LoginView(didCompleteLoginProcess: {
                    vm.isCurrentlyLoggedOut = false
                    vm.fetchCurrentUser()
                    vm.fetchAllUsers()
                })
            }
        }
    }
    
    var settingBar: some View {
        HStack {
            Spacer()
            Button {
                isShowingLogOut.toggle()
            } label: {
                Image(systemName: "gearshape")
                    .foregroundColor(.black)
            }
        }
        .confirmationDialog(Text("Settings"), isPresented: $isShowingLogOut, titleVisibility: .visible) {
            Button("Sign Out") {
                vm.handleSignOut()
            }
        }
        .padding(.horizontal)
    }
    
    var customNavigationBar: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(vm.user?.username ?? "Unknown")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 16, height: 16)
                    Text("Online")
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            WebImage(url: vm.user?.profileImageUrl)
                .resizable()
                .scaledToFill()
                .frame(width:64, height: 64)
                .clipped()
                .cornerRadius(64)
                .overlay(RoundedRectangle(cornerRadius: 64)
                            .stroke(.black, lineWidth: 1))


        }
        .padding()
    }
    

    var friendsLists: some View {
        ForEach(vm.users.filter({ $0.username.contains(searchText) || searchText.isEmpty })) { user in
            VStack {
                HStack(spacing: 16) {
                    WebImage(url: user.profileImageUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipped()
                        .cornerRadius(50)
                        .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(.black, lineWidth: 1))

                    Text(user.username)
                        .font(.system(size: 24, weight: .semibold))

                    Spacer()
                }
                .padding(.horizontal)
                Divider()
            }
        }
    }
}


    
    
    
    
    

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
    }
}
