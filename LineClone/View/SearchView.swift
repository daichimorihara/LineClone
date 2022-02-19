//
//  SearchBar.swift
//  LineClone
//
//  Created by Daichi Morihara on 2022/02/18.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @FocusState private var searchIsFocused: Bool
    
    var body: some View {
        HStack {
            HStack {
                TextField("Friends", text: $searchText)
                    .padding(.horizontal)
                    .focused($searchIsFocused)
                    
            }
            .padding()
            .background(.gray.opacity(0.2))
            .padding(.horizontal)
            .onTapGesture {
                isSearching = true
                searchIsFocused = true
            }
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                    Spacer()
                    if !searchText.isEmpty {
                        xButton
                    }
                }
                .foregroundColor(.gray.opacity(0.6))
                .padding(.horizontal, 24)
            )
            .transition(.move(edge: .trailing))
            .animation(.spring())
            
            if isSearching {
                cancelButton
            }
        }
    }
    
    var xButton: some View {
        Button {
            searchText = ""
        } label: {
            Image(systemName: "xmark.circle.fill")
        }
    }
    
    var cancelButton: some View {
        Button {
            isSearching = false
            searchText = ""
            searchIsFocused = false
        } label: {
            Text("Cancel")
                .foregroundColor(.blue)
                .padding(.trailing, 10)
                .padding(.leading, -16)
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchText: .constant("Friends"), isSearching: .constant(true))
    }
}
