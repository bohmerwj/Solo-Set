//
//  SoloSet.swift
//  Solo-Set
//
//  Created by duser on 3/18/18.
//  Copyright © 2018 William Bohmer. All rights reserved.
//

import Foundation

struct SoloSet {
    var cardDeck = [Card]()
    var layoutMat = [Int: Card?]()
    var cardsDealt = 0
    var selectedCardsIndices = [Int]()
    var matchedCardsShowing = 0
    var isMatchedGood = false
    var openSpots = [Int]()

    
    init() {
        // create Array of 81 Cards
        cardDeck = [Card]()
        cardsDealt = 0
        var aCard = Card()
        for symbol in 1...3 {
            for number in 1...3 {
                for shading in 1...3 {
                    for color in 1...3 {
                        aCard.symbol = symbol
                        aCard.numberOfSymbols = number
                        aCard.symbolShading = shading
                        aCard.symbolColor = color
                        cardDeck += [aCard]
                    }
                }
            }
        }
        for index in 0..<24 {
            layoutMat[index] = nil
        }
        
        shuffle()
        deal(amount: 12)
    }
    
    mutating func shuffle() {
        var randomInt: Int
        for index in 0..<cardDeck.count {
            randomInt = cardDeck.count.arc4random
            cardDeck.swapAt(index, randomInt)
        }
    }
    
    
    mutating func chooseCard(at index: Int) {
        assert(cardDeck.indices.contains(index), "SetSolo.chooseCard(at: \(index)): chosen index not in card")
        
        if selectedCardsIndices.count == 3 {
            if isMatchedGood { /* remove matched */
                for selectedCardsIndex in 0...2 {
                    layoutMat[selectedCardsIndices[selectedCardsIndex]] = nil
                }
                isMatchedGood = false
                selectedCardsIndices.removeAll()
                deal(amount: 3)
                return
            }
            else {
                selectedCardsIndices.removeAll()
            }
        }
        else {
            /* remove (deselect) duplicated selection */
            let selectionPosition = selectedCardsIndices.index(of:index)
            if selectionPosition != nil {
                selectedCardsIndices.remove(at:selectionPosition!)
                return
            }
        }
        
        selectedCardsIndices.append(index)
        if selectedCardsIndices.count == 3 {
            isMatchedGood = isMatched(indices: selectedCardsIndices)
            
        }
        
        
    }
    func isMatched(indices: [Int]) -> Bool {
        let card1 = layoutMat[selectedCardsIndices[0]]!!
        let card2 = layoutMat[selectedCardsIndices[1]]!!
        let card3 = layoutMat[selectedCardsIndices[2]]!!
        
        /* Check if symbol all same or all different */
        if (card1.symbol == card2.symbol), (card2.symbol == card3.symbol) {
            
        }
        else if (card1.symbol != card2.symbol), (card1.symbol != card3.symbol),(card2.symbol != card3.symbol) {
        }
        else {
            return false
        }
        
        /* Check if numberOfSymbols all same or all different */
        if (card1.numberOfSymbols == card2.numberOfSymbols), (card2.numberOfSymbols == card3.numberOfSymbols) {
            
        }
        else if (card1.numberOfSymbols != card2.numberOfSymbols), (card1.numberOfSymbols != card3.numberOfSymbols),(card2.numberOfSymbols != card3.numberOfSymbols) {
        }
        else {
            return false
        }
        
        /* Check if shading all same or all different */
        if (card1.symbolShading == card2.symbolShading), (card2.symbolShading == card3.symbolShading) {
            
        }
        else if (card1.symbolShading != card2.symbolShading), (card1.symbolShading != card3.symbolShading),(card2.symbolShading != card3.symbolShading) {
        }
        else {
            return false
        }
        
        /* Check if color all same or all different */
        if (card1.symbolColor == card2.symbolColor), (card2.symbolColor == card3.symbolColor) {
            
        }
        else if (card1.symbolColor != card2.symbolColor), (card1.symbolColor != card3.symbolColor),(card2.symbolColor != card3.symbolColor) {
        }
        else {
            return false
        }
        
        /* all 4 characteristics are the same or different */
        return true
    }
    
    mutating func deal (amount: Int) {
        
        if selectedCardsIndices.count == 3 {
            if isMatchedGood { /* remove matched */
                for selectedCardsIndex in 0...2 {
                    layoutMat[selectedCardsIndices[selectedCardsIndex]] = nil
                }
                isMatchedGood = false
            }
        }
        
        selectedCardsIndices.removeAll()
        
        if cardsDealt + amount > 81 {
            return
        }
        
        openSpots = [Int]()
        for index in 0..<24 {
            if layoutMat[index] == nil {
                openSpots += [index]
            }
        }
        
        if openSpots.count < amount {
            return
        }
        for index in 0..<amount {
            layoutMat[openSpots[index]] = cardDeck[cardsDealt+index]
        }
        
        cardsDealt += amount
        openSpots = [Int]()
        for index in 0..<24 {
            if layoutMat[index] == nil {
                openSpots += [index]
            }
        }
    
        return
        
    }
}



