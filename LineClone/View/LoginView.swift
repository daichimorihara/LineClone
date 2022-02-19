//
//  LoginView.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/17.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    let didCompleteLoginProcess: () -> ()
    
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    @State private var image: UIImage?
    @State private var isShowingImagePicker = false
    @State private var iconAlert = false
    @State private var invalidAlert = false
    @State private var waiting = false
    
    // variable for testing
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        loginPicker
                        loginInput
                        if !isLoginMode { iconButton }
                        submitButton
                        
                        // text for testing
                        //Text(errorMessage)
                    }
                    .padding(.horizontal)
                }
                if waiting {
                    Color.white
                    ProgressView()
                        .scaleEffect(2)
                }
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
        

    }
    
    var loginPicker: some View {
        Picker("Picker", selection: $isLoginMode) {
            Text("Log In")
                .tag(true)
            
            Text("Create Account")
                .tag(false)
        }
        .pickerStyle(.segmented)
    }
    
    var loginInput: some View {
        VStack {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            
            SecureField("Password", text: $password)
        }
        .padding()
    }
    
    var iconButton: some View {
        Button {
            isShowingImagePicker.toggle()
        } label: {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 128, height: 128)
                    .clipped()
                    .cornerRadius(64)
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 64))
                    .padding(10)
            }
        }
        .foregroundColor(.gray)
        .overlay(RoundedRectangle(cornerRadius: 64).stroke(.gray ,lineWidth: 1))
        
    }
    
    var submitButton: some View {
        Button {
            if isLoginMode {
                loginUser()
                waiting = true
            } else {
                createAccount()
                waiting = true
            }
            
        } label: {
            if isLoginMode {
                Text("Log In")
            } else {
                Text("Create Account")
            }
        }
        .foregroundColor(.white)
        .padding()
        .background(.blue)
        .cornerRadius(5)
        .alert("You must choose your icon image" , isPresented: $iconAlert) {
            Button("OK", role: .cancel) { waiting = false }
        }
        .alert("Invalid email or password", isPresented: $invalidAlert) {
            Button("OK", role: .cancel) { waiting = false }
        }
        
        
    }
    
    func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                invalidAlert.toggle()
                self.errorMessage = "Failed to login user: \(error)"
                print("Failed to login user: \(error)")
                return
            }
            self.errorMessage = "Successfully logged in user \(result?.user.uid ?? "")"
            print("Successfully logged in user \(result?.user.uid ?? "")")
            waiting = false
            
            didCompleteLoginProcess()
            
        }
    }
    
    func createAccount() {
        if image == nil {
            iconAlert.toggle()
            return
        }
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                invalidAlert.toggle()
                print("Failed to create a new account: \(error)")
                self.errorMessage = "Failed to create a new account: \(error)"
                return
            }
            print("Successfully created a new account")
            self.errorMessage = "Successfully created a new account"
            
            self.persistImageToStorage()
        }
    }
    
    func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to put image to Storage: \(error)")
                self.errorMessage = "Failed to put image to Storage: \(error)"
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve URL: \(error)")
                    self.errorMessage = "Failed to retrieve URL: \(error)"
                    return
                }
                print("Successfully save data in Storage with url")
                self.errorMessage = "Successfully save data in Storage with url"
                guard let url = url else { return }
                
                self.storeUserInfo(imageProfileUrl: url)
            }
        }
    }
    
    func storeUserInfo(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let document = FirebaseManager.shared.firestore.collection("users").document(uid)
        let user = User(id: document.documentID, email: email, profileImageUrl: imageProfileUrl)
        
        do {
            try document.setData(from: user)
            print("Successfully store user info in firestore")
            self.errorMessage = "Successfully store user info in firestore"
            waiting = false
            didCompleteLoginProcess()
        } catch {
            print("Failed to store user info in firestore: \(error)")
            self.errorMessage = "Failed to store user info in firestore: \(error)"
        }
    }
                    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didCompleteLoginProcess: { })
    }
}
