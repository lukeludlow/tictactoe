//
//  ContentView.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-25.
//

import SwiftUI

struct LandmarkDetail: View {
    var body: some View {
        VStack {
            MapView()
                .frame(height: 300)
            CircleImage()
                .offset(y: -130)
                .padding(.bottom, -130)
            VStack(alignment: .leading) {
                Text("lol xd")
                    .font(.title)
                    .foregroundColor(.blue)
                HStack {
                    Text("hi")
                        .font(.subheadline)
                    Spacer()
                    Text("park")
                        .font(.subheadline)
                }
            }
            .padding()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail()
    }
}
