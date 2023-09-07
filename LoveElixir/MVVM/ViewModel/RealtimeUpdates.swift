//
//  RealtimeUpdates.swift
//  LoveElixir
//
//  Created by Apple  on 31/08/23.
//

import Foundation
import Firebase
import SwiftUI
import Firebase

import Combine
import FirebaseFirestore


class RealtimeUpdatesViewModel: ObservableObject {
    
    @AppStorage("USER_NAME") var userID = ""
    @Published var disableFirstNotification = false
    
    
    @Published var requests: [[String: Any]] = [] {
           didSet {
               // Check if a new value was appended
               if requests.count > oldValue.count {
                   if let newElement = requests.last?["name"] as? String {
                       print("New element added: \(newElement)")
                       print("New element added: \(newElement)")
                       print("New element added: \(newElement)")
                       print("New element added: \(newElement)")
                       print("New element added: \(newElement)\n\n\n\n")
                       
                       if disableFirstNotification{
                           let notify = NotificationHandler()
                           notify.sendNotification(date: Date(), type: "time", timeInterval: 1, title:"Happy News 🥳" , body: "\(newElement) liked your profile , accept the request")
                       }
                                                    
                       
                   }
               }
           }
       }
    
    
    
    private var listener: ListenerRegistration?
    
    init(){
        listenForRequests()
    }
    func listenForRequests(){
        let db = Firestore.firestore()
        let currentUserID = userID
        let connectionRef = db.collection("PendingConnection").document(currentUserID)
        
        listener = connectionRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            
            if let document = documentSnapshot, document.exists {
                if let requestsArray = document.data()?["requests"] as? [[String: Any]] {
                    self.requests = requestsArray
                    self.disableFirstNotification = true
                }
            }
        }
    }
    
    func stopListening() {
        listener?.remove()
    }
    
    static func sendRequest(currentUserID: String, otherUser: User) {
        let db = Firestore.firestore()
        //let connectionRef = db.collection("PendingConnection").document(currentUserID)
        
        let connectionRef = db.collection("PendingConnection").document(otherUser.id)
        
        connectionRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            
            if let document = documentSnapshot, document.exists {
                var connectionsArray = document.data()?["requests"] as? [[String: Any]] ?? []
                
                connectionsArray.append(["id": currentUserID, "name": currentUserID])
                
                connectionRef.updateData(["requests": connectionsArray]) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            } else {
                let newDocumentData: [String: Any] = ["requests": [["id": currentUserID, "name": currentUserID]]]
                
                connectionRef.setData(newDocumentData) { error in
                    if let error = error {
                        print("Error creating document: \(error.localizedDescription)")
                    } else {
                        print("Document successfully created")
                    }
                }
            }
        }
    }
    
    
    static func removeRequest(currentUserID: String, otherUserID: String) {
        let db = Firestore.firestore()
        let connectionRef = db.collection("PendingConnection").document(otherUserID)
        
        connectionRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            
            if let document = documentSnapshot, document.exists {
                var connectionsArray = document.data()?["requests"] as? [[String: Any]] ?? []
                
                // Find and remove the request with the specified ID
                connectionsArray.removeAll { request in
                    if let id = request["id"] as? String {
                        return id == currentUserID
                    }
                    return false
                }
                
                // Update the document with the modified requests array
                connectionRef.updateData(["requests": connectionsArray]) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        print("Request successfully deleted")
                    }
                }
            }
        }
    }

    
    
    
//    static func removeRequest(currentUserID: String, otherUser: User) {
//        let db = Firestore.firestore()
//        let connectionRef = db.collection("PendingConnections").document(currentUserID)
//
//        connectionRef.getDocument { documentSnapshot, error in
//            if let error = error {
//                print("Error fetching document: \(error.localizedDescription)")
//                return
//            }
//
//            if let document = documentSnapshot, document.exists {
//                var connectionsArray = document.data()?["requests"] as? [[String: Any]] ?? []
//
//                connectionsArray.append(["id": otherUser.id, "name": otherUser.name])
//
//                connectionRef.updateData(["requests": connectionsArray]) { error in
//                    if let error = error {
//                        print("Error updating document: \(error.localizedDescription)")
//                    } else {
//                        print("Document successfully updated")
//                    }
//                }
//            } else {
//                let newDocumentData: [String: Any] = ["requests": [["id": otherUser.id, "name": otherUser.name]]]
//
//                connectionRef.setData(newDocumentData) { error in
//                    if let error = error {
//                        print("Error creating document: \(error.localizedDescription)")
//                    } else {
//                        print("Document successfully created")
//                    }
//                }
//            }
//        }
//    }
}
