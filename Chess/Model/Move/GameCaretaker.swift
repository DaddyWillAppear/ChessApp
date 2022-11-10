//
//  GameCaretaker.swift
//  Chess
//
//  Created by Николай Щербаков on 14.09.2022.
//

import Foundation

class GameCaretaker {
    var gameStates = StackLinkedList<GameMemento>()
    var tmpMemento: GameMemento?
}
