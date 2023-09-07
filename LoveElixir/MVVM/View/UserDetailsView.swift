//
//  UserDetailsView.swift
//  LoveElixir
//
//  Created by Apple  on 28/08/23.
//

import SwiftUI

struct UserDetailsView: View {
    @State var user:UserModel
    var body: some View {
        VStack{
            HStack{
                Image(user.about)
                    .resizable()
                    .cornerRadius(radius: 22.0, corners: [.bottomLeft,.bottomRight])
                
            }
          
           
            .overlay(alignment:.bottom){
                HStack(spacing:40){
                    Image(systemName: "xmark")
                      .resizable()
                      .frame(width: 20, height: 20)
                      .foregroundColor(.red)
                      .padding(20)
                      .background(Color.white)
                      .clipShape(Circle())
                      .shadow(color:.black,radius: 5)
                    
                    Image(systemName: "heart.fill")
                      .resizable()
                      .frame(width: 20, height: 20)
                      .foregroundColor(.white)
                      .padding(20)
                      .background(Color.pink)
                      .clipShape(Circle())
                      .scaleEffect(1.26)
                      .shadow(color:.black,radius: 5)
                    
                    Image(systemName: "checkmark")
                      .resizable()
                      .frame(width: 20, height: 20)
                      .foregroundColor(.green)
                      .padding(20)
                      .background(Color.white)
                      .clipShape(Circle())
                      .shadow(color:.black,radius: 5)
                }
                .frame(width: 200,height: 50)
//                .background(.red)
                .offset(y:20)
            }
            VStack(spacing:20){
                HStack{
                    VStack(alignment:.leading){
                        Text("Mia , 20")
                            .font(.title)
                            .bold()
                        Text("Kerala,India")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                   
                }
               
                    VStack(alignment:.leading){
                        Text("About")
                            
                        Text("/Users/apple/Library/Developer/Xcode/UserData/Previews/Simulator Devices/8857FBD5-A738-470E-8EBF-601058771389/data/Containers/Bundle/Application/F87255D6-809F-4290-9207-98C9B8124045/LoveElixir.app")
                            .foregroundColor(.gray)
                        
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
        
                VStack{
                    VStack(alignment:.leading,spacing: 10){
                        Text("Interests")
                            .frame(maxWidth: .infinity,alignment: .leading)
                        HStack(spacing:20){
                            Text("Music")
                                .padding(5)
                                .background(.green.opacity(0.5))
                                .cornerRadius(6)
                            Text("Coding")
                                .padding(5)
                                .background(.pink.opacity(0.5))
                                .cornerRadius(6)
                            Text("Sports")
                                .padding(5)
                                .background(.yellow.opacity(0.5))
                                .cornerRadius(6)
                        }
                        HStack{
                            Text("Football")
                                .padding(5)
                                .background(.blue.opacity(0.5))
                                .cornerRadius(6)
                            Text("Dancing")
                                .padding(5)
                                .background(.brown.opacity(0.5))
                                .cornerRadius(6)
                            Text("Swimming")
                                .padding(5)
                                .background(.red.opacity(0.5))
                                .cornerRadius(6)
                        }
                    }
                }
                .frame(maxHeight: .infinity,alignment: .top)
            }
            .padding(20)
            
        }//:Vstack
        .ignoresSafeArea()
        .frame(maxHeight: .infinity,alignment: .top)
        ///for top custom back button
//        .overlay(alignment:.topLeading){
//            Button {
//                print("backbutton")
//            } label: {
//                Rectangle()
//                    .foregroundColor(.white.opacity(0.7))
//                    .frame(width: 50,height: 50)
//                    .cornerRadius(25)
//                    .padding()
//                    .overlay(alignment:.center){
//                        Image(systemName: "chevron.backward")
//                    }
//            }
//            .shadow(radius: 2)
//
//        }
        
       
    }
}

//struct UserDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailsView()
//    }
//}



//Custom CornerRadius to give corner radius to specific parts
struct CornerRadiusShape: Shape {
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
