//
//  LazyView.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-30.
//

import SwiftUI

struct LazyView<Content: View>: View {
    var content: () -> Content
    var body: some View {
        self.content()
    }
}
