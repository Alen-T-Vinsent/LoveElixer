//
//  AcceptRequestView.swift
//  LoveElixir
//
//  Created by Apple  on 29/08/23.
//

import SwiftUI

struct AcceptRequestView: View {
    @ObservedObject var realtimeVm:RealtimeUpdatesViewModel
   
    
    struct IndexedConnection: Identifiable {
           let id = UUID()
           let index: Int
           let connection: [String: Any]
       }
       
       var indexedConnections: [IndexedConnection] {
           Array(realtimeVm.requests.enumerated()).map { index, connection in
               IndexedConnection(index: index, connection: connection)
           }
       }
       
    
    
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(indexedConnections) { indexedConnection in
                    VStack{
                               AcceptRequestCard(image: indexedConnection.connection["about"] as? String ?? "bg-1",
                                                 name: indexedConnection.connection["name"] as? String ?? "",
                                                 id:indexedConnection.connection["id"] as? String ?? "")
                             
                  
                    }
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.horizontal,5)

                }
            }
        }
      
    }
}

struct AcceptRequestCard: View {
    @AppStorage("USER_NAME") var userName:String = ""
    @State var image:String
    @State var name:String
    @State var id:String
    var body: some View {
        VStack{
            HStack{
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 70,height: 70)
                .cornerRadius(35)
                .shadow(radius: 1)
        
                Text(name)
                    .font(.headline)
                Text("|")
                    .foregroundColor(.gray)
                
                Text("Match \(Int.random(in: 85...99))%")
                
                NavigationLink("  read more..", destination:{
                    UserDetailsView(user: UserModel(id: id, name: name, userName: name, about: name, userPicURL: image))
                })
                .font(.footnote)
                
               
            }
            .frame(maxWidth: .infinity,alignment: .topLeading)
            
            
            HStack{
                
                Button {
                    print("Accept button pressed")
                    RealtimeUpdatesViewModel.removeRequest(currentUserID: "Alen", otherUserID: id)
                    Task{
                        await FirebaseDummy.addConnection(currentUserID: "Alen", newConnectionID: [id])
                    }
                } label: {
                    HStack{
                        Text("Accept")
                            .padding(5)
                            .foregroundColor(.white)
                           
                        
                     
                    }
                    .padding(4)
                    .background(.black)
                    .cornerRadius(6)
                }


               
                Button {
                    print("Decline button pressed")
                    RealtimeUpdatesViewModel.removeRequest(currentUserID:userName, otherUserID: id)
                } label: {
                    HStack{
                        Text("Decline")
                            .padding(4)
                            .foregroundColor(.black)
                 
                    }
                    .padding(4)
                    .background(.white)
                    .border(.black)
                    
                }

               


            }
            
        
            
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(10)
        .foregroundColor(.black)
        }
}

//
//struct AcceptRequestView_Previews: PreviewProvider {
//    static var previews: some View {
//        AcceptRequestView()
//    }
//}
