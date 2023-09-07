//
//  Ad+StackView.swift
///  This view is responsible to show ads and stack of profiles
///  If the array of profiles become empty the ad will pop up with simple animation and user wont be able to swipe the ad card
///  Ad will show when availble stack of profiles become empty


import SwiftUI

struct Ads_and_StackView: View {
    
    @EnvironmentObject var appManagerVm:AppManagerViewModel
    @EnvironmentObject var userVm:UserViewModel

    
    var body: some View {
        ZStack{
            if appManagerVm.usersArray.isEmpty{
                StackCardView(otherUser: UserModel(id: "", name: "", userName: "", about: "travel-1", userPicURL: ""))
                    .allowsHitTesting(false)
//                    .overlay(alignment:.topLeading){
//
//                        HStack(alignment:.center){
//                            Button {
//                                print("upload all data")
//                                appManagerVm.uploadDataArray()
//                            } label: {
//                                VStack{
//                                    Image(systemName: "restart.circle.fill")
//                                    Text("upload")
//                                }
//                                .padding()
//                            }
//
//                            Spacer()
//
//                            Button {
//                                print("get all data")
//                                appManagerVm.fetchDataArray()
//                            } label: {
//                                VStack{
//                                    Image(systemName: "square.and.arrow.down.fill")
//                                    Text("get")
//                                }
//                                .padding()
//                            }
//
//                            Spacer()
//
//                            Button {
//                                print("delete all data")
//                                appManagerVm.deleteDataArray()
//                            } label: {
//                                VStack{
//                                    Image(systemName: "xmark.diamond")
//                                    Text("delete")
//                                }
//                                .padding()
//                            }
//
//                        }
//                        .padding(.top)
//                        .foregroundColor(.black)
//
//                    }
            }else{
                ForEach(appManagerVm.usersArray.reversed(),id:\.self){ eachUser in
                    NavigationLink {
                        UserDetailsView(user: eachUser)
                    } label: {
                        StackCardView(otherUser: eachUser)
                        
                            ///by tapping on the above stack 2 times will add this user to the likedProfile inside LikedProfileViewModel
//                            .onTapGesture(count: 2) {
//                                let tappedUser = User(id: UUID(), name: girlPic)
//                                likedVm.likedProfiles.insert(tappedUser)
//                            }
                    }
                    

                }
            }//:else
        }//:ZStack
        //.frame(maxWidth: 300,maxHeight: 500)
    }
    
    
}

//struct HomeTesting_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(Data())
//    }
//}
