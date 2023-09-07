//
//  MakeConnectionView-location.swift
//  LoveElixir
//
//  Created by Apple  on 14/08/23.
//

import SwiftUI

struct NearByView: View {
    @ObservedObject var realtimeVm:RealtimeUpdatesViewModel
    
    @State var showProgress = true
    var body: some View {
        ZStack{
            
            //                //background
            //                Image("bg-17")
            //                    .resizable()
            //                    .frame(maxWidth: .infinity,maxHeight: .infinity)
            //                    .ignoresSafeArea()
            //
            
            RadialGradient(gradient: Gradient(colors: [.gray, .black]), center: .center, startRadius: 2, endRadius: 550)
            
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .ignoresSafeArea()
            
            
            //main
            VStack(spacing:0){
                
                if realtimeVm.requests.isEmpty{
                    Text("No one send request..")
                }else{
                    withAnimation {
                        AcceptRequestView(realtimeVm: realtimeVm)
                        
                    }
                    
                }
                
            }
            .padding(.top)
            
            
            
        }
        
        
    }
}

//    struct nearbyPreview: PreviewProvider {
//        static var previews: some View {
//            ContentView()
//        }
//    }
