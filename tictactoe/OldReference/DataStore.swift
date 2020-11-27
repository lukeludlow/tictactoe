//
//  DataStore.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-25.
//

import SwiftUI
import Combine

final class DataStore: ObservableObject {
    @Published var showFavoritesOnly = false
    @Published var landmarks = landmarkData
    @Published var profile = Profile.default
}
