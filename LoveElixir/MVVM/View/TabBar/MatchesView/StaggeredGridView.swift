//
//  StaggeredGridView.swift
//  LoveElixir
//
//  Created by Apple  on 26/08/23.
import SwiftUI

struct StaggredGridView:View{
    @State var columns:Int = 2
    @Binding var status:Status
    @Binding var setOfUsers:Set<User>
    //smooth hero effect
    @Namespace var animation
    
    var body: some View{
        
        
       // NavigationView {
            StaggeredGrid(columns: columns, list:Array(setOfUsers),content:{ index in
                Image("\(index.name)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .matchedGeometryEffect(id: index.id, in: animation)
            })
            .overlay(alignment:.top){
                HStack{
                    Spacer()
                    
                    Button("-") {
                        columns += 1
                    }
                    
                    Button("+") {
                        
                        
                            columns = max(columns - 1,1)
                 
                    }
                }
                
                .padding(.top,50)//arrages + and - padding
                .padding(.trailing,20)
                .shadow(radius: 8)
               
            }
            .animation(.easeOut, value: columns)
       // }//nav
    }
    
}

struct StaggeredGrid<Content:View,T:Identifiable>:View where T:Hashable{
    var content:(T)->Content
    var list:[T]
    
    
    //Columns
    var columns:Int
    
    //Properties
    var showIndicators:Bool
    var spacing:CGFloat
    
    //Staggered Grid Function
    func setUpList()->[[T]]{
        var gridArray:[[T]] = Array(repeating: [], count: columns)
        
        //splitting Array for vstack oriented View...
        var currentIndex = 0
        
        for object in list{
            print(object)
            print(list)
            print(gridArray)
            gridArray[currentIndex].append(object)
            
            if currentIndex == (columns - 1){
                currentIndex = 0
            }else{
                currentIndex += 1
            }
        }
        
        return gridArray
    }
    
    
    init(columns:Int,showsIndicator:Bool = false , spacing:CGFloat = 10 , list: [T], @ViewBuilder content: @escaping (T)->Content) {
        self.content = content
        self.list = list
        self.spacing = spacing
        self.showIndicators = showsIndicator
        self.columns = columns
    }
    
    var body: some View{
        ScrollView(.vertical,showsIndicators:showIndicators){
            
//            HStack{
//
//            }
//            .frame(height: 80)
//
            Spacer(minLength: 80)
            
            
            HStack(alignment:.top){
                ForEach(setUpList(),id:\.self){ columnsData in
                    LazyVStack(spacing: spacing) {
                        ForEach(columnsData){object in
                            content(object)
                            
                        }
                    }
                }
            }
            
            HStack{
                
            }
            .frame(height: 100)
        }
    }
}









