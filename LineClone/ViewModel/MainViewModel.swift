//
//  MainViewModel.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/18.
//

import Foundation
import Firebase

class MainViewModel: ObservableObject {
    @Published var recentMessages = [RecentMessage]()
    
    init() {
        //fetch recent messages
        fetchRecentMessage()
        
    }
    
    func fetchRecentMessage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                querySnapshot?.documentChanges.forEach { change in
                    let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    if let rm = try? change.document.data(as: RecentMessage.self) {
                        self.recentMessages.insert(rm, at: 0)
                    }
                    
                }
            }
    }
}
