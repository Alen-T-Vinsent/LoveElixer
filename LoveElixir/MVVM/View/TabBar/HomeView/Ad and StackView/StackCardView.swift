//
//  HomeViewTesting.swift
//  LoveElixir
//
//  Created by Apple  on 14/08/23.
//

import SwiftUI
import URLImage

struct StackCardView: View{
    
    @AppStorage("LOGIN_STATUS") var isLoggedIn:Bool = false
    @AppStorage("USER_NAME") var userName:String = ""

    @EnvironmentObject var appManagerVm:AppManagerViewModel
    @EnvironmentObject var userVm:UserViewModel
    
    //Gesture Properties
    @State var offset:CGFloat = 0
    @GestureState var isDragging = false
    @State var endSwipe = false
    
    //Alen
    @State var swipeStatusScale:CGFloat = 0.0
    
    //@State var girlPic:String =  "girl2"
    @State var otherUser:UserModel
    
    //@State var user:User
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let index = CGFloat(getIndex(user:otherUser.name))
            
            //to show next two card behind current card
            let topOffset = (index<=2 ? index : 2) * 15
            
            ZStack{
                Image(otherUser.about)
               
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - topOffset,height: size.height)
                    .cornerRadius(10)
                    .offset(y:-topOffset)
            }//:ZStack
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
        }//:Geometry Reader
        .offset(x:offset)
        .rotationEffect(.init(degrees: getRotation(angle: 8)))
        .contentShape(Rectangle().trim(from: 0, to: endSwipe ? 0 : 1))
        .overlay(alignment:.center){
            //used to show like logo and dislike logo
            if swipeStatusScale>45{
                Image(systemName: "hand.thumbsup.fill")
                    .resizable()
                    .foregroundColor(.green)
                    .frame(width: 100,height: 100)
            }else if(swipeStatusScale < -45){
               Image(systemName: "hand.thumbsdown.fill")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 100,height: 100)
            }
        }
        .gesture(
            DragGesture()
                .updating($isDragging, body: { value, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let traslation = value.translation.width
                    offset = (isDragging ? traslation : .zero)
                    print(traslation)
                    print(type(of: traslation))
                    
                    let width = getRect().width - 50
                    
                    
                    swipeStatusScale = traslation
                    
                    if traslation>45{
                        print("show liked logo")
                    }else if(traslation < -45){
                        print("show dislike dislike")
                    }
                    
                    
                })
            
                
                .onEnded({ value in
                    let width = getRect().width - 50
                    let translation = value.translation.width
                    let checkingStatus = (translation > 0 ? translation : -translation)
                    
                    swipeStatusScale = 0.0
                    
                    withAnimation {
                        if checkingStatus > (width/2){
                            //remove card
                            
                            offset = (translation > 0 ? width : -width) * 2
                            endSwipeAction()
                            
                            if translation > 0{
                                print("rightSwipe")
                            
                                
                                let user = User(id: otherUser.id, name: otherUser.about)
                                userVm.likedProfiles.insert(user)
                                
                                Task{
                                    await FirebaseDummy.addToLikedProfiles(currentUserID:userName, likedUserId: [otherUser.id])
                                }
                                
                                RealtimeUpdatesViewModel.sendRequest(currentUserID:userName, otherUser: User(id: otherUser.id, name: otherUser.name))
                                
//                                //alen created this delete
//                                let notify = NotificationHandler()
//                                notify.sendNotification(date: Date(), type: "time", timeInterval: 1, title:"Happy News 🥳" , body: "\(otherUser.name) liked your profile , accept the request")
                                
                            }else{
                                print("left swipe")
                                //add it to dis-liked Array
                                userVm.disLikedProfiles.insert(User(id: userName, name: otherUser.about))
                                Task{
                                    await FirebaseDummy.addToDisLikedProfiles(currentUserID:userName, dislikedUserId: [otherUser.id])
                                }
                            }
                        }else{
                            //reset
                            offset = .zero
                            
                        }
                    }
                })
        )
        //used onrecieve and notification center to control the swipe without touching the screen
        .onReceive(
            NotificationCenter.default.publisher(for: Notification.Name("ACTION_FROM_BUTTON"),object: nil)) { data in
                guard let info = data.userInfo else{
                    return
                }
                
                let id = info["id"] as? String ?? ""
                let rightSwipe =  info["rightSwipe"] as? Bool ?? false
                
                if  otherUser.id == id{
                    
                }
            }
    }
    
    //MARK: Functions
    func getIndex(user:String)->Int{
        let index = appManagerVm.usersArray.firstIndex(where: { currentUser in
            return user == currentUser.name
        }) ?? 0
        
        print(index,"-<--<index")
        return index
    }
    
    func getRotation(angle:Double)->Double{
        let rotation = (offset/(getRect().width - 50)) * angle
        return rotation
    }
    
    func endSwipeAction(){
        withAnimation(.none){
            endSwipe = true
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                //                if let _ = Data.girlsArray.first{
                let _ = withAnimation {
                    appManagerVm.usersArray.removeFirst()
                }
            }
            
        }
    }
    
    
    func doSwipe(rightSwipe:Bool = false){
        guard let first = appManagerVm.usersArray.first else{
            return
        }
        
        NotificationCenter.default.post(
            name:NSNotification.Name("ACTION_FROM_BUTTON"),
            object: nil,
            userInfo: ["id":first,"rightSwipe":rightSwipe]
        )
    }
    
    
    
    
}



extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
