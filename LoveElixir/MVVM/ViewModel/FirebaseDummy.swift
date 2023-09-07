//
//  FirebaseDummy.swift
//  LoveElixir
//
//  Created by Apple  on 31/08/23.
//

import Foundation

import Firebase
class FirebaseDummy{
    
   
    
    static func fetchUsers(completion: @escaping ([UserModel], Error?) -> Void) {
        Firestore.firestore().collection("Users").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion([], error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion([], nil)
                return
            }
            
            let users: [UserModel] = documents.compactMap { document in
                let data = document.data()
                if let userModel = UserModel(data: data) {
                    return userModel
                } else {
                    // Handle invalid data here if needed
                    return nil
                }
            }
            
            completion(users, nil)
        }
    }

        
    
    
//    static func fetchUsers(completion: @escaping ([User]?, Error?) -> Void) {
//        Firestore.firestore().collection("Users").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//
//            guard let documents = querySnapshot?.documents else {
//                completion([], nil)
//                return
//            }
//
//            let users:[User] = documents.compactMap { document in
//                let data = document.data()
//                guard let id = data["id"] as? String,
//                      let name = data["name"] as? String else {
//                    return nil
//                }
//                return User(id: id, name: name)
//            }
//
//
//            completion(users, nil)
//        }
//
//    }
//
    static func deleteUsersCollection() {
            let db = Firestore.firestore()
            
            db.collection("Users").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found to delete")
                    return
                }
                
                let batch = db.batch()
                for document in documents {
                    batch.deleteDocument(document.reference)
                }
                
                batch.commit { error in
                    if let error = error {
                        print("Error deleting documents: \(error.localizedDescription)")
                    } else {
                        print("Documents deleted successfully")
                    }
                }
            }
        }
        
        
    static func uploadFullDataToFirebase() {
           let db = Firestore.firestore()
        
        let girlsArray = ["girl-1","girl-2","girl-3","girl-4","girl-5","girl-6","girl-7"]
           
           for girl in girlsArray {
               //  // Assuming `girl` is a string
               let girlDict: [String: Any] = [
                                              "name": girl,
                                              "id":UUID().uuidString,
                                              "connections":[String]()
                                             ]
               
               
               let docId = girlDict["id"]
               
             
               // Create a reference to the document
                   let documentRef = db.collection("Users").document(docId as! String)
               
               // Set data for the document
                      documentRef.setData(girlDict) { error in
                          if let error = error {
                              print("Error uploading data: \(error.localizedDescription)")
                          } else {
                             
                              print("Data uploaded successfully")
                          }
                      }
           }
       }
    
    
    static func searchName(forId searchId: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")
        
        usersCollection.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(nil)
                return
            }
            
            for document in documents {
                if let documentData = document.data() as? [String: Any],
                   let id = documentData["id"] as? String,
                   id == searchId,
                   let name = documentData["about"] as? String {
                    completion(name)
                    return
                }
            }
            
            completion(nil) // No match found
        }
    }

    
    static func getOneUserDictData(forDocumentWithId docRef: DocumentReference) async throws -> [String: Any]? {
print("one user dict")
        let documentRef = docRef
        
        do {
            let documentSnapshot = try await documentRef.getDocument()
            if let documentData = documentSnapshot.data() {
                print("documentData")
                print(documentData)
                return documentData
            } else {
                print("nill")
                print("nill")
                print("nill")
                return nil // Document not found or data couldn't be parsed
            }
        } catch {
            print("before throw")
            print("before throw")
            throw error
        }
    }

    
    
//    static func addConnection(currentUserID docId: String,newConnectionID: [String]) async {
//        let db = Firestore.firestore()
//
//        // Create a reference to the document
//        let documentRef = db.collection("Users").document(docId)
//
//
//
//        var latestUserDict:[String:Any] = [:]
//
//        //below do catch block will get one user dict
//        // Update the connections array in the dictionary
//        do {
//            if let oneUserDict = try await getOneUserDictData(forDocumentWithId: documentRef){
//                print("user Dict got")
//                latestUserDict = oneUserDict
//
//                if oneUserDict.isEmpty{
//
//                    do{
//                        // Set data for the document
//                        try?  documentRef.setData(["connections":[String]() ]) { error in
//                            if let error = error {
//                                print("Error uploading data: \(error.localizedDescription)")
//                            } else {
//                                print(latestUserDict)
//                                print("Data uploaded successfully")
//                            }
//                        }//:
//                    }catch{
//                        print("error")
//                    }
//                }
//
//            }else{
//                print("Document not found , or parsed")
//
//            }
//        }catch{
//            print("erro get to catch f=il")
//        }
//
//
//
//
//
//
//        if var connections = latestUserDict["connections"] as? [String] {
//            for each in newConnectionID{
//                connections.append(each)
//            }
//            latestUserDict["connections"] = connections
//        }
//
//        // Set data for the document
//        documentRef.setData(latestUserDict) { error in
//            if let error = error {
//                print("Error uploading data: \(error.localizedDescription)")
//            } else {
//                print(latestUserDict)
//                print("Data uploaded successfully")
//            }
//        }
//    }
//
    static func addToLikedProfiles(currentUserID docId: String, likedUserId: [String]) async {
        let db = Firestore.firestore()
        
        // Create a reference to the document
        let documentRef = db.collection("Users").document(docId)
        
        do {
            // Get the existing user dictionary data
            var latestUserDict = try await getOneUserDictData(forDocumentWithId: documentRef) ?? [:]
            
            // Initialize connections array if empty
            if latestUserDict["likedProfiles"] == nil {
                latestUserDict["likedProfiles"] = [String]()
            }
            
            // Add new connection IDs to the connections array
            if var connections = latestUserDict["likedProfiles"] as? [String] {
                connections.append(contentsOf: likedUserId)
                latestUserDict["likedProfiles"] = connections
            }
            
            // Set data for the document
            try await documentRef.setData(latestUserDict)
            print("Data uploaded successfully")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
   
    
    
    static func getLikedProfiles(forUserId userId: String,completion:@escaping([String])->Void) async -> [String]? {
        let db = Firestore.firestore()
        do {
            let documentRef = db.collection("Users").document(userId)
            let documentSnapshot = try await documentRef.getDocument()
            
            if let data = documentSnapshot.data(),
               let likedProfiles = data["likedProfiles"] as? [String] {
                print(likedProfiles)
                print("likedProfiles")
                completion(likedProfiles)
                return likedProfiles
            } else {
                print("Liked profiles not found for user: \(userId)")
                return nil
            }
        } catch {
            print("Error fetching liked profiles: \(error.localizedDescription)")
            return nil
        }
    }

    
    static func getDisLikedProfiles(forUserId userId: String,completion:@escaping([String])->Void) async -> [String]? {
        let db = Firestore.firestore()
        do {
            let documentRef = db.collection("Users").document(userId)
            let documentSnapshot = try await documentRef.getDocument()
            
            if let data = documentSnapshot.data(),
               let dislikedProfiles = data["dislikedProfiles"] as? [String] {
                print(dislikedProfiles)
                print("dislikedProfiles")
                completion(dislikedProfiles)
                return dislikedProfiles
            } else {
                print("dislikedProfiles profiles not found for user: \(userId)")
                return nil
            }
        } catch {
            print("Error fetching dislikedProfiles profiles: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    static func getConnectionProfiles(forUserId userId: String) async -> [String]? {
        let db = Firestore.firestore()
        do {
            let documentRef = db.collection("Users").document(userId)
            let documentSnapshot = try await documentRef.getDocument()
            
            if let data = documentSnapshot.data(),
               let connections = data["connections"] as? [String] {
                print(connections)
                print("connections")
                return connections
            } else {
                print("connections profiles not found for user: \(userId)")
                return nil
            }
        } catch {
            print("Error fetching connections profiles: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    
    
    static func removeFromLikedProfiles(currentUserID docId: String, dislikedUserId: [String]) async {
        let db = Firestore.firestore()
        
        // Create a reference to the document
        let documentRef = db.collection("Users").document(docId)
        
        do {
            // Get the existing user dictionary data
            var latestUserDict = try await getOneUserDictData(forDocumentWithId: documentRef) ?? [:]
            
            // Check if the "likedProfiles" array exists
            if var likedProfiles = latestUserDict["likedProfiles"] as? [String] {
                // Remove disliked user IDs from the array
                likedProfiles = likedProfiles.filter { !dislikedUserId.contains($0) }
                latestUserDict["likedProfiles"] = likedProfiles
                
                // Set data for the document
                try await documentRef.setData(latestUserDict)
                print("Data uploaded successfully")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    
    static func addToDisLikedProfiles(currentUserID docId: String, dislikedUserId: [String]) async {
        let db = Firestore.firestore()
        
        // Create a reference to the document
        let documentRef = db.collection("Users").document(docId)
        
        do {
            // Get the existing user dictionary data
            var latestUserDict = try await getOneUserDictData(forDocumentWithId: documentRef) ?? [:]
            
            // Initialize connections array if empty
            if latestUserDict["dislikedProfiles"] == nil {
                latestUserDict["dislikedProfiles"] = [String]()
            }
            
            // Add new connection IDs to the connections array
            if var connections = latestUserDict["dislikedProfiles"] as? [String] {
                connections.append(contentsOf: dislikedUserId)
                latestUserDict["dislikedProfiles"] = connections
            }
            
            // Set data for the document
            try await documentRef.setData(latestUserDict)
            print("Data uploaded successfully")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    static func addConnection(currentUserID docId: String, newConnectionID: [String]) async {
        let db = Firestore.firestore()
        
        // Create a reference to the document
        let documentRef = db.collection("Users").document(docId)
        
        do {
            // Get the existing user dictionary data
            var latestUserDict = try await getOneUserDictData(forDocumentWithId: documentRef) ?? [:]
            
            // Initialize connections array if empty
            if latestUserDict["connections"] == nil {
                latestUserDict["connections"] = [String]()
            }
            
            // Add new connection IDs to the connections array
            if var connections = latestUserDict["connections"] as? [String] {
                connections.append(contentsOf: newConnectionID)
                latestUserDict["connections"] = connections
            }
            
            // Set data for the document
            try await documentRef.setData(latestUserDict)
            print("Data uploaded successfully")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    
    
    static func sendRequest(currentUserID:String,otherUser:User){
        
    }
    
    static func fetchCompleteGirlsData( completion:@escaping([User])->Void) {
            let db = Firestore.firestore()
            
            db.collection("Users").addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }
                
                var newData: [String: [String: Any]] = [:]
                var newArray:[User] = []
                for document in documents {
                    if let data = document.data() as? [String: Any] {
                        newData[document.documentID] = data
                    }
                }
                
                newArray = newData.map { key, value in
                                   let name = value["name"] as? String ?? ""
                                   let id = value["id"] as? String ?? ""
                                   return User(id: id, name: name)
                               }
                
                print(newData)
                print(newArray)
                completion(newArray)
            }
        }
    
    
    
    static func createConnection(currentUser:User,otherUser:User){
        let db = Firestore.firestore()
        
        let connectionID = currentUser.id+"->"+otherUser.id
        
        //document Reference inside Collection
        let connectionRef = db.collection("Connections").document(connectionID)
        
        let connectionDict:[String:Any] = ["connectionStatus":"pending"]
        
        connectionRef.setData(connectionDict){ error in
            if let error = error {
                print("Error -> createConnection : \(error.localizedDescription)")
            } else {
                print("new connection created successfully -> createConnection")
            }
            
        }
        
    }
    
    
    //working code
    //if the below condition is true we dont want to create a connection
    //if the condition is false we do need to create connection
    static func isConnectionExist(currentUser:User , otherUser:User,completion:@escaping(Bool)->()){
        let db = Firestore.firestore()
        
//        let connectionID = otherUser.id+"->"+currentUser.id
        
        let connectionRef = db.collection("Users").document(currentUser.id)
        
        connectionRef.getDocument{document , error in
            if (error != nil) == true {
                print("inside eror, failed to fetch document....")
                completion(false)
            }
            
            if let document = document,document.exists{
                completion(true)
            }else{
                completion(false)
                
                ///we need to create new connection
                
                FirebaseDummy.createConnection(currentUser:currentUser, otherUser: otherUser)
            }
        }
    }
    
    
}


