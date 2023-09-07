//
//  MatchesViewModel.swift
//  LoveElixir
//
//  Created by Apple  on 26/08/23.
//

import Foundation
import SwiftUI

//this viewmodel has complete details about the current user
///this includes , liked Array of users , disliked array of Users etc.....
class UserViewModel:ObservableObject{
    
    @AppStorage("LOGIN_STATUS") var isLoggedIn:Bool = false
    @AppStorage("USER_NAME") var userName:String = ""
    
    
    
    @Published var likedProfiles:Set<User> = []
    @Published var disLikedProfiles:Set<User> = []
    
    //this varible changes accordint to the selction of segmented picker 
    @Published var setToDisplay:Set<User>  = []
    
    private func fetchLikedProfiles(){
        Task{
            await FirebaseDummy.getLikedProfiles(forUserId: userName) { likedArray in
                
                for id in likedArray{
                    
                    FirebaseDummy.searchName(forId: id) { name in
                        if let name = name{
                            let user = User(id: id, name: name)
                            self.likedProfiles.insert(user)
                            self.setToDisplay.insert(user)
                        }else{
                            print("name not found",name ?? "UNKNOWN")
                        }
                    }
                   
                }
                
            }
        }//Task
    }
    private func fetchDislikedProfiles(){
        Task{
            await FirebaseDummy.getDisLikedProfiles(forUserId: userName) { dislikedArray in
                
                for id in dislikedArray{
                    
                    FirebaseDummy.searchName(forId: id) { name in
                        if let name = name{
                            let user = User(id: id, name: name)
                            self.disLikedProfiles.insert(user)
                        }else{
                            print("name not found",name ?? "UNKNOWN")
                        }
                    }
                   
                }
                
            }
        }//Task
    }
    
    init() {
        fetchLikedProfiles()
        fetchDislikedProfiles()
        
    }
}

class AppManagerViewModel:ObservableObject{
    @Published var usersArray:[UserModel] = []
    
    init() {
        FirebaseDummy.fetchUsers { users, error in
            self.usersArray = users
        }
    }
    
    func deleteDataArray(){
        FirebaseDummy.deleteUsersCollection()
    }

    func uploadDataArray(){
        FirebaseDummy.uploadFullDataToFirebase()
    }
    
    
//    func fetchUserArray(){
//        FirebaseDummy.fetchUserArray { usersArray, error in
//            self.usersArray = usersArray ?? []
//        }
//    }
//    
    
    func fetchDataArray(){
        FirebaseDummy.fetchUsers { usersArray, error in
            self.usersArray = usersArray ?? []
        }
    }
}
