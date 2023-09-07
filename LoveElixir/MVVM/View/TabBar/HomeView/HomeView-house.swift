//
//  HomeView-house.swift
//  LoveElixir
//
//  Created by Apple  on 14/08/23.
//

import SwiftUI

struct HomeView: View {
        var body: some View {
            ZStack{
                RadialGradient(gradient: Gradient(colors: [.gray, .black]), center: .center, startRadius: 2, endRadius: 550)
                
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .ignoresSafeArea()
                
                //main
                VStack{
                    ///this view is responsible to show Ad and Stack of profiles
                    ///if the stack of profiles is empty it will show the ad with swipe disabled
                    Ads_and_StackView()
                }
                
 
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
          
           

        }
    }



//struct HomeView_house_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(Data())
//    }
//}
