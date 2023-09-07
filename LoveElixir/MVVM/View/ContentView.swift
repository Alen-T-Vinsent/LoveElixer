//
//  ContentView.swift
//  LoveElixir
//
//  Created by Apple  on 14/08/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: AppStorage
    @AppStorage("LOGIN_STATUS") var isLoggedIn:Bool = false
    @AppStorage("USER_NAME") var userName:String = "Alen"
    

    @State var showSplashScreen = true
    
    var body: some View {
        NavigationView{
            if showSplashScreen{
                SplashScreen()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline:.now()+3) {
                            withAnimation {
                                showSplashScreen = false
                            }
                        }
                    }
            }else{
                
                if isLoggedIn == true && !userName.isEmpty{
                    CustomTabbarView()
                }else{
                    LoginView()
                }
              
                
            }
//            in ipad also
        } //:NavigationView
        .navigationViewStyle(.stack)//to make it like a stack

       
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}



