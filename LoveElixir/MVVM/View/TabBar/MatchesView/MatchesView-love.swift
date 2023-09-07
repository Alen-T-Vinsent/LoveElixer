//
//  MatchesView.swift
//  LoveElixir
//
//  Created by Apple  on 14/08/23.
//

import SwiftUI


enum Status{
    case liked,disliked
}


struct MatchesView: View {
    
    @EnvironmentObject var userVm:UserViewModel
    @EnvironmentObject var appMangerVm:AppManagerViewModel
    
    @State var statusArray = ["liked","disliked"]
    @State var selectedItem = 0
    @State var status:Status = .liked
    @State var setToDisplay:Set<User>  = []
    
   
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .black
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    
    var body: some View {
        ZStack{
            
            //background
//            Image("bg-15")
//                .resizable()
//
//                .frame(maxWidth: .infinity,maxHeight: .infinity)
//                .ignoresSafeArea()
            
            RadialGradient(gradient: Gradient(colors: [.gray, .black]), center: .center, startRadius: 2, endRadius: 550)
            
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .ignoresSafeArea()
                
            
            
            //main
            VStack{
                StaggredGridView(status: $status, setOfUsers:$setToDisplay)
            }
            
            .padding()
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            
            .onAppear{
                setToDisplay = userVm.likedProfiles
            }

            VStack{
               
                Picker("Pick a language", selection: $selectedItem) {
                    ForEach(Array(statusArray.enumerated()), id: \.offset) { index,item in
                               Text(item.uppercased())
                                   .tag(index)
                           }
            
                    .onChange(of: selectedItem) { newValue in
                        print(selectedItem)
                        print(newValue)
                        if 0 == selectedItem{
                            setToDisplay = userVm.likedProfiles
                        }else{
                            setToDisplay = userVm.disLikedProfiles
                        }
                    }
                   
                   
                       }
                .pickerStyle(.segmented)
                .padding(.top,12)
                
            }
           
            .frame(maxHeight: .infinity,alignment: .top)
            

            
        }
 

    }
}

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

