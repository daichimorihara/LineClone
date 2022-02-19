//
//  ChatMessage.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/19.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct ChatMessage: Identifiable, Codable {
    @DocumentID var id: String?
    let text: String
    let fromId, toId: String
    let tiemstamp: Timestamp
    
}
