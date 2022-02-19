//
//  ChatLogViewModel.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/19.
//

import Foundation
import SwiftUI

class ChatLogViewModel: ObservableObject {
    @Published var chatMessages = [ChatMessage]()
    @Published var chatText = ""
    @Published var user: User?
    
    init(user: User?) {
        // fetch chat messages <-- listen for change
        self.user = user
        
    }
}
