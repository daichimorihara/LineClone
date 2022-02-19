//
//  ChatLogView.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/19.

import SwiftUI

struct ChatLogView: View {
    @ObservedObject var vm: ChatLogViewModel
    let user: User?
    
    init(user: User?) {
        self.user = user
        self.vm = .init(user: user)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                mainBody
                bottomBar
            }
            .navigationTitle(vm.user?.username ?? "Unknown")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        <#code#>
                    }
                }
            }
        }
    }


    var mainBody: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(1...21, id: \.self ) { idx in
                    Text("ibwbri")
                        .padding()
                }

                HStack { Spacer() }
                .frame(height: 50)
                .id("bottom")
            }
            .background(.blue.opacity(0.1))
            //.onReceive(<#T##publisher: Publisher##Publisher#>, perform: <#T##(Publisher.Output) -> Void#>)

        }
    }

    var bottomBar: some View {
        HStack {
            Image(systemName: "photo.on.rectangle")
            
            ZStack {
                descriptionPlaceHolder
                
                TextEditor(text: $vm.chatText)
                    .frame(height: 35)
                    .opacity(vm.chatText.isEmpty ? 0.1 : 1)
                
            }
            .background(.gray.opacity(0.1))
            
            Button {
                
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.blue)
            .cornerRadius(3)
        }
        .padding(5)
    }
    
    var descriptionPlaceHolder: some View {
        HStack {
            Text("Enter a message")
                .foregroundColor(.gray)
                .padding(.leading, 5)
            Spacer()
        }
        .frame(height: 35)
        
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLogView(user: nil)
    }
}
