//
//  LandmarkList.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-25.
//

import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        List {
            Toggle(isOn: $dataStore.showFavoritesOnly) {
                Text("favorites only")
            }
            ForEach(dataStore.landmarks) { landmark in
                if !self.dataStore.showFavoritesOnly || landmark.isFavorite {
                    NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
        }
        .navigationBarTitle(Text("landmarks"))
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LandmarkList()
                .environmentObject(DataStore())
        }
//        ForEach(["iPhone 11", "iPhone SE", "iPhone 12 Pro Max"], id: \.self) { deviceName in
//            LandmarkList()
//                .environmentObject(DataStore())
//                .previewDevice(PreviewDevice(rawValue: deviceName))
//                .previewDisplayName(deviceName)
//        }
    }
}
