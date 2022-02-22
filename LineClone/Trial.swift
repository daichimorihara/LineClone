//
//  Trial.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/20.
//

import SwiftUI

struct Trial: View {
    let user: User? = User(id:"YG0ZR5110NYk5fexxOiaQfMXvas1",
                           email: "emma@gmail.com",
                           profileImageUrl: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/lineclone-52aae.appspot.com/o/YG0ZR5110NYk5fexxOiaQfMXvas1?alt=media&token=6dc19610-d81c-4f2c-a08c-b4be75034a44")!)
    
    var data = [ChatMessage]()
    
    var body: some View {
        VStack {
            ForEach(data) { ff in
                Text(ff.text)
            }
        }
    }
    
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = user?.id else { return }
        
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .getDocuments() { querySnapshot, error in
                if let error = error {
                    print(error)
                } else {
                    for doc in querySnapshot!.documents {
                        let new = try? doc.data(as: ChatMessage.self)
                        print(new)
                    }
                }
            }
    }
}

//struct Trial_Previews: PreviewProvider {
//    static var previews: some View {
//        Trial()
//    }
//}
