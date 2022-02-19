//
//  FriendViewModel.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/18.
//

import Foundation

class FriendViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var user: User?
    @Published var isCurrentlyLoggedOut = false
    
    init() {
        fetchCurrentUser()
        fetchAllUsers()
        
        DispatchQueue.main.async {
            self.isCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser == nil
        }
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let document = FirebaseManager.shared.firestore.collection("users").document(uid)

        document.getDocument { doc, error in
            if let error = error {
                print("Failed to fetch current user: \(error)")
                return
            }
            if let doc = doc {
                do {
                    self.user = try doc.data(as: User.self)
                } catch {
                    print("Failed to fetch current user: \(error)")
                }
            }
        }
    }
    
    func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users").getDocuments{ documentsSnapshot, error in
            if let error = error {
                print("Failed to fetch users (friends): \(error)")
            }
            documentsSnapshot?.documents.forEach { snapshot in
                let user = try? snapshot.data(as: User.self)
                
                if let user = user {
                    if user.id != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user)
                    }
                }
            }
        }
    }
    
    func handleSignOut() {
        self.isCurrentlyLoggedOut = true
        try? FirebaseManager.shared.auth.signOut()
        users.removeAll()
        self.user = nil
    }
    
}
