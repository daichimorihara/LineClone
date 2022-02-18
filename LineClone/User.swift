//
//  User.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/17.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    
    let email: String
    let profileImageUrl: URL
    
    var username: String {
        email.components(separatedBy: "@").first?.capitalizingFirstLetter() ?? email
    }
}
