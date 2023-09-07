//
//  TapToLike.swift
//  LoveElixir
//
//  Created by Apple  on 26/08/23.
//

import SwiftUI

struct LikedList: View {
    @EnvironmentObject var userVm:UserViewModel
    var body: some View {
        VStack{
            List(Array(userVm.likedProfiles)){ user in
                Text(user.name)
                    .foregroundColor(.black)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40 , height: UIScreen.main.bounds.height - 180)
        .padding(.bottom,40)
    }
}


struct LikedListView:View{
    @State private var colors:[Color] = [.red,.blue,.purple,.pink,.yellow,.green,.accentColor,.black,.indigo,.mint,.orange,.brown,.cyan]
    
    @State var draggingItem:Color?

    
    @State var text:String = ""
    var body: some View{
    
        NavigationStack{
            ScrollView(.vertical){
                Text(text)
                let columns = Array(repeating: GridItem(spacing:10), count: 2)
                
                LazyVGrid(columns: columns,spacing: 10 , content:{
                    ForEach(colors,id: \.self) { color in
                        GeometryReader {
                            let size = $0.size
                            
                            RoundedRectangle(cornerRadius:10)
                                .fill(color.gradient)
                                .draggable(color){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.ultraThinMaterial)
                                        .frame(width: size.width,height: size.height)
                                }
                                .dropDestination(for:Color.self) { items, location in
                                    draggingItem = nil
                                    return false
                                }isTargeted: { status in
                                    self.text = "\(color)"
                                    if let draggingItem , status , draggingItem != color{
                                        if let sourceIndex = colors.firstIndex(of: draggingItem)
                                            ,let destinationIndex = colors.firstIndex(of: color){
                                            withAnimation{
                                                let sourceItem = colors.remove(at: sourceIndex)
                                                colors.insert(sourceItem, at:destinationIndex )
                                            }
                                        }
                                    }
                                }
                        }
                        .frame(height: 100)
                       
                    }
                })
                .padding(15)
            }
            .navigationTitle("Hello")
        }
    }
}






