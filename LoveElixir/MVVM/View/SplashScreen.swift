//
//  SplashScreen.swift
//  LoveElixir
//
//  Created by Apple  on 31/08/23.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        Image("logo-3")
            .resizable()
            .scaledToFit()
            .ignoresSafeArea()
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(.black)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
