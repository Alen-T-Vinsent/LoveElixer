//
//  CustomTabbarView.swift
//  LoveElixir
//
//  Created by Apple  on 14/08/23.
//

import SwiftUI

struct CustomTabbarView: View {
    
    
    @StateObject var appManagerVm = AppManagerViewModel()
    @StateObject var userVm = UserViewModel()
    
    
    
    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color("tabBarColor-2"), Color("tabBarColor-1")]), startPoint: .leading, endPoint: .trailing)
    
   //@State properties
    @State var selectedTab:tabsEnum = .home
    @State var selecteTabColor:Color = .gray
    
    
    @StateObject var realtimeVm:RealtimeUpdatesViewModel = RealtimeUpdatesViewModel()
    
    
    enum tabsEnum{
        case home,love,location,message
    }
    var body: some View {
        VStack{
            switch selectedTab {
            case .home:
                HomeView()
            case .love:
                MatchesView()
                    .foregroundColor(.white)
            case .location:
                NearByView(realtimeVm: realtimeVm)
                    .foregroundColor(.white)
            case .message:
                MessageView()
                    .foregroundColor(.white)
            }
               
        } .overlay(alignment:.bottom){
                ZStack{
                    RoundedRectangle(cornerSize: CGSize(width: 35, height: 35))
                        .fill(linearGradient)
                        .frame(height: 70)
                        .padding(.bottom,20)
                        .frame(maxWidth: 250)
                    
                    HStack(spacing:30){
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width:25 ,height: 25)
                            .foregroundColor(selectedTab == .home ? selecteTabColor : .black)
                            .onTapGesture {
                                selectedTab = .home
                            }
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width:25 ,height: 25)
                            .foregroundColor(selectedTab == .love ? selecteTabColor : .black)
                            .onTapGesture {
                                selectedTab = .love
                            }
                        Image(systemName: "mappin.circle.fill")
                            .resizable()
                            .frame(width:30 ,height: 30)
                            .foregroundColor(selectedTab == .location ? selecteTabColor : .black)
                            .onTapGesture {
                                selectedTab = .location
                            }
                        Image(systemName: "message.badge.circle.fill")
                            .resizable()
                            .frame(width:30 ,height: 30)
                            .foregroundColor(selectedTab == .message ? selecteTabColor : .black)
                            .onTapGesture {
                                selectedTab = .message
                            }
                        
                        
                    }
                        .frame(height: 70)
                        .padding(.bottom,20)
                   
                    
                }//:Zstack
                
                
            }
            //.ignoresSafeArea()
        
            .environmentObject(appManagerVm)
            .environmentObject(userVm)
    }
}

//struct CustomTabbarView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(Data())
//    }
//}
