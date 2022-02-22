//
//  FirebaseManager.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/17.
//

import Foundation
import Firebase

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    var currentUser: User?
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        
        super.init()
    }
    
}
