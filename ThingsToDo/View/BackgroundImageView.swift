//
//  BackgroundImageView.swift
//  ThingsToDo
//
//  Created by Kosei Ban on 2022-09-20.
//

import SwiftUI

struct BackgroundImageView: View {
    var body: some View {
        Image("rocket")
        .resizable()
        .scaledToFill()
        .ignoresSafeArea(.all)
    }
}

struct BackgroundImageView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundImageView()
    }
}
