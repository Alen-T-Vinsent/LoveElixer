//
//  MessageView.swift
//  LoveElixir
//
//  Created by Apple  on 14/08/23.
//

import SwiftUI

struct MessageView: View {
    
    //MARK: AppStorage
    @AppStorage("LOGIN_STATUS") var isLoggedIn:Bool = false
    @AppStorage("USER_NAME") var userName:String = ""
    
        var body: some View {
            ZStack{
                //background
                Image("bg-19")
                    .resizable()
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .ignoresSafeArea()
                
                //main
                VStack{
                    HStack{
                        
                    }
                    HStack{
                      Text("Chat is coming soon")
                    }
                    HStack{
                        
                    }
                    HStack{
                        
                    }
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .overlay(alignment:.topTrailing){
                    Button("logout"){
                        userName = ""
                        isLoggedIn = false
                    }
                    .padding()
                }
                
                
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
    }

    struct MessageViewPrev: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
