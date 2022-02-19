//
//  RecentMessage.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/19.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct RecentMessage: Identifiable, Codable {
    @DocumentID var id: String?
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: URL
    let timestamp: Date
    
    var username: String {
        email.components(separatedBy: "@").first?.capitalizingFirstLetter() ?? email
    }
    
    var time: String {
        let formatter = DateFormatter()
        let now = Date()
        let dayAgo = Date().advanced(by: -86400)
        let range = dayAgo...now
        if range.contains(timestamp) {
            formatter.dateFormat = "h:mm"
            return formatter.string(from: timestamp)
        } else {
            formatter.dateFormat = "M/dd"
            return formatter.string(from: timestamp)
        }
    }
}
