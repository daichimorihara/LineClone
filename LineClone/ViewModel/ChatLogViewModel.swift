//
//  ChatLogViewModel.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/19.
//

import Foundation
import Firebase

class ChatLogViewModel: ObservableObject {
    @Published var chatMessages = [ChatMessage]()
    @Published var chatText = ""
  //  @Published var user: User?
    @Published var count = 0
    
    let user: User?
    
    init(user: User?) {
        // fetch chat messages <-- listen for change
        self.user = user
        fetchMessages()
    }
    
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = user?.id else { return }
        
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Failed to fetch snapshot")
                    return
                }
                snapshot.documentChanges.forEach { change in
                    if change.type == .added {
                        if let newMessage = try? change.document.data(as: ChatMessage.self) {
                            print("ijfoisfnovonvd")
                            self.chatMessages.append(newMessage)
                        }
              }
                }
//                DispatchQueue.main.async {
//                    self.count += 1
//                }
            }
    }
    
    
    // Mark - Intents
    func handleSend() {
        if self.chatText.isEmpty {
            return
        }
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = user?.id else { return }
        
        let document = FirebaseManager.shared.firestore.collection("messages").document(fromId).collection(toId).document()
        let data = ChatMessage(id: document.documentID, text: chatText, fromId: fromId, toId: toId, tiemstamp: Timestamp())
        do {
            try document.setData(from: data)
        } catch {
            print("Failed to send chat message: \(error)")
        }
        
        let recipientDoc = FirebaseManager.shared.firestore.collection("messages").document(toId).collection(fromId).document()
        
        let recipientData = ChatMessage(id: recipientDoc.documentID, text: chatText, fromId: fromId, toId: toId, tiemstamp: Timestamp())
        do {
            try recipientDoc.setData(from: recipientData)
        } catch {
            print("Failed to recieve chat message: \(error)")
        }
        
        self.persistRecentMessage()
        
//        self.chatText = ""
    }
    
    func persistRecentMessage() {
        guard let chatUser = self.user else { return }
        guard let toId = user?.id else { return }
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let recentMessage = RecentMessage(id: document.documentID, text: chatText, email: chatUser.email, fromId: uid, toId: toId, profileImageUrl: chatUser.profileImageUrl, timestamp: Date())
        
        do {
            try document.setData(from: recentMessage)
        } catch {
            print("Failed to save current messages to firestore: \(error)")
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { document, error in
            let result = Result {
                try? document?.data(as: User.self)
            }
            switch result {
            case .success(let currentUser):
                if let currentUser = currentUser {
                    let recipientDoc = FirebaseManager.shared.firestore
                        .collection("recent_messages")
                        .document(toId)
                        .collection("messages")
                        .document(uid)
                    
                    let recipientMsg = RecentMessage(id: recipientDoc.documentID, text: self.chatText, email: currentUser.email, fromId: uid, toId: toId, profileImageUrl: currentUser.profileImageUrl, timestamp: Date())
                    
                    do {
                        try recipientDoc.setData(from: recipientMsg)
                    } catch {
                        print("Failed to recieve recent message: \(error)")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        

        
        
        
    }
}
