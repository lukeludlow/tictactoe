//
//  GameView.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-27.
//

import Foundation
import SwiftUI
import ToastUI
import Combine

struct GameView: View {
    
    @ObservedObject var viewModel: GameViewViewModel
    @State var showingNotTurnAlert: Bool = false
    @State var showingInvalidMoveAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var database: FirebaseDatabaseStore
    
    func dismissSelf() {
        print("dismiss")
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func incrementPlayerWins() {
        print("increment player wins")
        for player in self.database.players {
            if player.uid == self.session.session?.uid {
                player.wins += 1
                player.ref?.updateChildValues(["wins": player.wins])
            }
        }
    }
    
    func toggleCell(cell: Cell) {
        print("clicked cell \(cell.row),\(cell.col) \(cell.value.rawValue)")
        if cell.value == XO.empty {
            if self.viewModel.currentPlayerTurn == self.viewModel.playerOne {
                self.viewModel.toggleCell(cell: cell)
                if self.viewModel.winner == self.viewModel.playerOne {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                        self.incrementPlayerWins()
                    })
                }
            } else {
                self.showingNotTurnAlert = true
            }
        } else {
            self.showingInvalidMoveAlert = true
        }
    }
    
    var body: some View {
        VStack {
            Text("\(viewModel.currentPlayerTurn)'s turn")
                .font(.title)
                .padding()
            VStack {
                ForEach(self.viewModel.cells, id: \.self) { cellRow in
                    HStack {
                        ForEach(cellRow, id: \.self) { cell in
                            Button(action: {
                                self.toggleCell(cell: cell)
                            }) {
                                Text("\(cell.value.rawValue)")
                                    .font(.largeTitle)
                                    .frame(width: 100, height: 100)
                            }
                            .frame(width: 100, height: 100)
                            .border(Color.black, width: 1)
                            .alert(isPresented: $showingNotTurnAlert) {
                                Alert(title: Text("it's not your turn yet"), dismissButton: .default(Text("ok")))
                            }
                            .alert(isPresented: $showingInvalidMoveAlert) {
                                Alert(title: Text("that square is already taken"), dismissButton: .default(Text("ok")))
                            }
                            if cell.col == 0 || cell.col == 1 {
                                let offset = CGFloat(1.2)
                                GeometryReader { geometry in
                                    Path { path in
                                        path.move(to: CGPoint(x: 0, y: 60 * (1 - offset)))
                                        path.addLine(to: CGPoint(x: 0, y: geometry.size.height * offset))
                                    }
                                    .stroke(Color.black, lineWidth: 5)
                                }
                                .frame(width: 5, alignment: .center)
                            }
                        }
                    }
                    if cellRow[0].row == 0 || cellRow[0].row == 1 {
                        let offset = CGFloat(0.05)
                        GeometryReader { geometry in
                            Path { path in
                                path.move(to: CGPoint(x: geometry.size.width * offset, y: 0))
                                path.addLine(to: CGPoint(x: geometry.size.width * (1 - offset), y: 0))
                            }
                            .stroke(Color.black, lineWidth: 5)
                        }
                        .frame(height: 5, alignment: .center)
                    }
                }
            }
            .aspectRatio(1.0, contentMode: .fit)
            .alert(isPresented: self.$viewModel.isComplete) {
//                let button = Alert.Button.default(Text("ok")) {
//                    print("ok button pressed")
//                    dismissSelf()
//                }
//                return Alert(title: Text("game over"), message: Text("\(self.viewModel.winner) wins!"), dismissButton: button)
                Alert(title: Text("game over"), message: Text("\(self.viewModel.winner) wins!"), dismissButton: .default(Text("ok"), action: {
                    print("ok button pressed")
                    dismissSelf()
                }))
            }
//            .toast(isPresented: self.$viewModel.isComplete, dismissAfter: 2.0) {
//                print("dismiss")
//                self.presentationMode.wrappedValue.dismiss()
//            } content: {
//                ToastView {
//                    VStack {
//                        Text("game over. \(self.viewModel.winner) wins!")
//                            .padding()
//                        Button("ok") {
//                            self.viewModel.isComplete = false
//                        }
//                    }
//                }
//            }
        }
    }
    
//    @State var cells: [[Cell]] = []
//    @State var currentPlayerTurn: String
//    @State var playerOne: String
//    @State var playerTwo: String
//    @State var isComplete: Bool
//    @State var winner: String
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewViewModel(
                                playerOne: "luwuke",
                                playerTwo: "CPU",
                                session: SessionStore(),
                                database: FirebaseDatabaseStore()))
    }
}
