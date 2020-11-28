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
    
//    @ObservedObject var viewModel: GameViewViewModel
    @State var showingNotTurnAlert: Bool = false
    @State var showingInvalidMoveAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var database: FirebaseDatabaseStore
    
    @State var cells: [[Cell]] = []
    @State var currentPlayerTurn: String = ""
    @State var playerOne: String = ""
    @State var playerTwo: String = ""
    @State var isComplete: Bool = false
    @State var winner: String = ""
    
    init(playerOne: String, playerTwo: String) {
        print("init GameView")
        cells = [
            [Cell(row: 0, col: 0, value: XO.empty), Cell(row: 0, col: 1, value: XO.empty), Cell(row: 0, col: 2, value: XO.empty)],
            [Cell(row: 1, col: 0, value: XO.empty), Cell(row: 1, col: 1, value: XO.empty), Cell(row: 1, col: 2, value: XO.empty)],
            [Cell(row: 2, col: 0, value: XO.empty), Cell(row: 2, col: 1, value: XO.empty), Cell(row: 2, col: 2, value: XO.empty)]
        ]
        self.playerOne = playerOne
        self.playerTwo = playerTwo
        self.currentPlayerTurn = playerOne
        self.isComplete = false
        self.winner = ""
    }
    
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
    
    func onClickCell(cell: Cell) {
        print("clicked cell \(cell.row),\(cell.col) \(cell.value.rawValue)")
        if cell.value == XO.empty {
            if self.currentPlayerTurn == self.playerOne {
                self.toggleCell(cell: cell)
                if self.winner == self.playerOne {
                    self.incrementPlayerWins()
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
            Text("\(self.currentPlayerTurn)'s turn")
                .font(.title)
                .padding()
            VStack {
                ForEach(self.cells, id: \.self) { cellRow in
                    HStack {
                        ForEach(cellRow, id: \.self) { cell in
                            Button(action: {
                                self.onClickCell(cell: cell)
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
            .alert(isPresented: $isComplete) {
//                let button = Alert.Button.default(Text("ok")) {
//                    print("ok button pressed")
//                    dismissSelf()
//                }
//                return Alert(title: Text("game over"), message: Text("\(self.viewModel.winner) wins!"), dismissButton: button)
                Alert(title: Text("game over"), message: Text("\(self.winner) wins!"), dismissButton: .default(Text("ok"), action: {
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
    

    
    func tick() {
        self.winner = detectWinner()
        if self.winner != "" {
            print("game over, \(self.winner) won")
//            if winner == playerOne {
//                incrementPlayerWins()
//            } else if winner == playerTwo {
                // decrementPlayerWins()
//            }
            self.isComplete = true
            return
        }
        if !anyEmptyCells() {
            print("game over, no empty cells")
            if self.winner == "" {
                self.winner = "nobody"
            }
            self.isComplete = true
            return
        }
        if currentPlayerTurn == "CPU" && !isComplete {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                self.cpuMakeMove()
            })
        }
    }
    
    func detectWinner() -> String {
        // check for horizontal three in a row
        for row in cells {
            if row.allSatisfy({ $0.value == XO.x }) {
                return playerOne
            } else if row.allSatisfy({ $0.value == XO.o }) {
                return playerTwo
            }
        }
        // check for vertical three in a row
        for i in 0...2 {
            if cells.allSatisfy({ $0[i].value == XO.x }) {
                return playerOne
            } else if cells.allSatisfy({ $0[i].value == XO.o }) {
                return playerTwo
            }
        }
        // check for diagonal three in a row
        let diagonalPermutations: [[(Int, Int)]] = [
            [(0, 0), (1, 1), (2, 2)],
            [(2, 0), (1, 1), (0, 2)]
        ]
        for diagonal in diagonalPermutations {
            if diagonal.allSatisfy({ cells[$0.0][$0.1].value == XO.x }) {
                return playerOne
            } else if diagonal.allSatisfy({ cells[$0.0][$0.1].value == XO.o }) {
                return playerTwo
            }
        }
        return ""
    }
    
    func toggleCell(cell: Cell) {
        print("toggleCell. cell.row=\(cell.row), cell.col=\(cell.col), currentPlayerTurn=\(currentPlayerTurn)")
        if currentPlayerTurn == playerOne {
            self.cells[cell.row][cell.col].value = XO.x
            currentPlayerTurn = playerTwo
        } else {
            self.cells[cell.row][cell.col].value = XO.o
            currentPlayerTurn = playerOne
        }
        tick()
    }
    
    func cpuMakeMove() {
        if (anyEmptyCells() && currentPlayerTurn == "CPU") {
            print("cpu make move")
            let emptyCells = self.cells.flatMap({ $0 }).filter { $0.value == XO.empty }
            let cellToChange = emptyCells.randomElement()!
            print("cpu chose cell at \(cellToChange.row),\(cellToChange.col)")
            self.cells[cellToChange.row][cellToChange.col].value = XO.o
            currentPlayerTurn = playerOne
        }
        tick()
    }
    
    func anyEmptyCells() -> Bool {
        let emptyCells = self.cells.flatMap({ $0 }).filter { $0.value == XO.empty }
        return emptyCells.count > 0
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(playerOne: "luwuke", playerTwo: "CPU")
//        GameView(viewModel: GameViewViewModel(
//                                playerOne: "luwuke",
//                                playerTwo: "CPU",
//                                session: SessionStore(),
//                                database: FirebaseDatabaseStore()))
    }
}
