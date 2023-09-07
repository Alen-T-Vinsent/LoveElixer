//
//  UserModel.swift
//  LoveElixir
//
//  Created by Apple  on 26/08/23.
//

import Foundation

struct User:Identifiable,Hashable,Equatable{
    var id: String
    let name:String
}


struct UserModel:Identifiable,Hashable,Equatable{
    var id:String
    var name:String
    var userName:String
    var about:String
    var userPicURL:String
    
    init(id: String, name: String, userName: String, about: String, userPicURL: String) {
        self.id = id
        self.name = name
        self.userName = userName
        self.about = about
        self.userPicURL = userPicURL
    }
    
    
    init?(data: [String: Any]) {
           guard let id = data["id"] as? String,
                 let name = data["name"] as? String,
                 let userName = data["userName"] as? String,
                 let about = data["about"] as? String,
                 let picUrl = data["userPicURL"] as? String else {
               return nil
           }
           
           self.id = id
           self.name = name
           self.userName = userName
           self.about = about
           self.userPicURL = picUrl
       }
    

}

