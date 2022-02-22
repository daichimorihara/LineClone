//
//  ChatLogView.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/19.

import SwiftUI

struct ChatLogView: View {
    @ObservedObject var vm2: ChatLogViewModel
    let user: User?
    @Environment(\.dismiss) var dismiss

    
    init(user: User?) {
        self.user = user
        self.vm2 = .init(user: user)
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                mainBody
                Button {
                    vm2.fetchMessages()
                    vm2.count += 1
                } label: {
                    Text("Fetch")
                }
                bottomBar
            }
            .onAppear(perform: vm2.fetchMessages)
            .navigationTitle(vm2.user?.username ?? "Unknown")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }


    var mainBody: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(vm2.chatMessages) { message in
                    Text(message.text)
                }
                ForEach(1...20, id: \.self) { idx in
                    Text("OK")
                }

                HStack { Spacer() }
                .frame(height: 50)
                .id("bottom")
            }
            .padding(.top, 1)
            .background(.blue.opacity(0.1))
            .onReceive(vm2.$count) { _ in
                
            }

        }
    }

    var bottomBar: some View {
        HStack {
            Image(systemName: "photo.on.rectangle")
            
            ZStack {
                descriptionPlaceHolder
                
                TextEditor(text: $vm2.chatText)
                    .frame(height: 35)
                    .opacity(vm2.chatText.isEmpty ? 0.1 : 1)
                
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
