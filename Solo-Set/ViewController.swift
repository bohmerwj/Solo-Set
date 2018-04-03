//
//  ViewController.swift
//  Solo-Set
//
//  Created by duser on 3/17/18.
//  Copyright © 2018 William Bohmer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.setTitle(nil, for: UIControlState.normal)
            button.layer.cornerRadius = 8.0
        }
        
        game = SoloSet()
        updateCardLayout()
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateCardLayout()
        }
    }
    
    @IBAction func dealButtonAction(_ sender: UIButton) {
        game.deal(amount: 3)
        updateCardLayout()
    }
    
    @IBOutlet weak var dealButtonOutlet: UIButton!
    
    @IBAction func newGame(_ sender: UIButton) {
        newGame()
    }
    private let symbols = ["?","▲","●","■"]
    lazy var game = SoloSet()
    
    func newGame() {
        game = SoloSet()
        updateCardLayout()
    }
    
    func updateCardLayout(){
        /*   Check if Deal 3 More button should be disabled */
        var totalSpotsAvailable: Int
        totalSpotsAvailable = 0
        if game.isMatchedGood {
            totalSpotsAvailable += 3
        }
        totalSpotsAvailable += game.openSpots.count
        if  (game.cardsDealt < 81) && (totalSpotsAvailable > 0)  {
            dealButtonOutlet.isEnabled = true
            dealButtonOutlet.layer.borderWidth = 0.0
        }
        else {
            dealButtonOutlet.isEnabled = false
            dealButtonOutlet.layer.borderWidth = 3.0
            dealButtonOutlet.layer.borderColor = UIColor.red.cgColor
        }
        
        var layoutSymbols = ""
        var layoutSymbol = ""
        var layoutSelectionColor: CGColor
        var layoutColor: UIColor
        var attributes = [NSAttributedStringKey: Any]()
        var aCard = Card()
        
        for index in 0..<24 {
            cardButtons[index].layer.borderWidth = 0.0
            if game.layoutMat[index] != nil  {
                cardButtons[index].isEnabled = true
                cardButtons[index].backgroundColor = UIColor.white
                layoutSymbols = ""
                aCard = game.layoutMat[index]!!
                
                layoutSymbol = symbols[aCard.symbol]
                for _ in 0..<aCard.numberOfSymbols {
                    layoutSymbols += layoutSymbol
                }
                
                attributes = [NSAttributedStringKey: Any]()
                attributes[.font] = UIFont.systemFont(ofSize: 32.0)

                switch aCard.symbolColor {
                case 1:
                    layoutColor =  UIColor.cyan
                case 2:
                    layoutColor =  UIColor.magenta
                case 3:
                    layoutColor =  UIColor.green
                default:
                    layoutColor =  UIColor.red
                }

                switch aCard.symbolShading {
                case 1: /* Open */
                    attributes[.strokeWidth] =  5.0
                    attributes[.strokeColor] = layoutColor
                    attributes[.foregroundColor] = layoutColor
                case 2: /* Solid */
                    attributes[.strokeWidth] =  -5.0
                    attributes[.strokeColor] = layoutColor
                    attributes[.foregroundColor] = layoutColor
                case 3: /* Striped */
                    attributes[.strokeWidth] =  -5.0
                    attributes[.strokeColor] = UIColor.black /*layoutColor*/
                    attributes[.foregroundColor] =  layoutColor.withAlphaComponent(0.15)
                default:
                    attributes[.strokeWidth] =  3.0
                    attributes[.strokeColor] = UIColor.red
                }

                let attributedString = NSAttributedString(string: layoutSymbols, attributes: attributes)
                cardButtons[index].setAttributedTitle(attributedString, for: UIControlState.normal)
            }
            else {
                cardButtons[index].setAttributedTitle(nil, for: UIControlState.normal)
                cardButtons[index].isEnabled = false
                cardButtons[index].backgroundColor = UIColor.black

            }
            
        }
        layoutSelectionColor = UIColor.blue.cgColor
        for index in game.selectedCardsIndices {
            if game.selectedCardsIndices.count == 3 {
                if game.isMatchedGood {
                    layoutSelectionColor = UIColor.green.cgColor
                }
                else {
                    layoutSelectionColor = UIColor.red.cgColor
                }
            }
            cardButtons[index].layer.borderColor = layoutSelectionColor
            cardButtons[index].layer.borderWidth = 3.0
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else {
            return 0
        }
    }
}
