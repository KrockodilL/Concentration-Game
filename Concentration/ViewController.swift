//
//  ViewController.swift
//  Concentration
//
//  Created by Влад Кононенко on 25/06/2019.
//  Copyright © 2019 Влад Кононенко. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // init game
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // init array of emoji
    private lazy var emojiChoices = chooseTheme()
    
    // init Dictionary
    private var emoji = [Card : String]()
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet {
            updateGameScoreLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [CardButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmojiForCards()
        updateViewFromModel()
    }

    private func setupEmojiForCards() {
        cardButtons.enumerated().forEach { (index, button) in
            let card = game.cards[index]
            button.emoji = self.emoji(for: card)
        }
    }
    
    @IBAction private func touchCard(_ sender: CardButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction private func newGamePressed(_ sender: CardButton) {
        game.ended()
        // Forgot the emojis linked to the cards
        emoji = [:]
        // Choose new theme for a brand new game
        emojiChoices = chooseTheme()
        setupEmojiForCards()
        updateViewFromModel()
    }
    
    private func updateGameScoreLabel() {
        let attributes : [NSAttributedString.Key : Any ] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Счет : \(game.score)", attributes: attributes)
        scoreLabel.attributedText = attributedString
    }
    
    private func updateViewFromModel() {
        cardButtons.enumerated().forEach { (index, button) in
            button.card = game.cards[index]
        }
        updateGameScoreLabel()
    }
    
    private func emoji(for card: Card) -> String {
        
        if emoji[card] == nil , emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.randomNumber)
        }
        
        return emoji[card] ?? "?"
    }
    
    private func chooseTheme() -> [String] {
        
        // Emoji sets
        var emojiSets = [[String]]()
        
        emojiSets.append(["😈","💀","👹","🎃","👽","👻","🤖","🤡"])
        emojiSets.append(["🥶","🏂","❄️","🛷","⛄️","☁️","🍧","⛸"])
        emojiSets.append(["🐰","🦊","🐷","🐵","🐮","🐸","🐤","🐼"])
        emojiSets.append(["😎","😳","😣","😡","🤩","🙄","😊","🥺","😓","😬"])
        emojiSets.append(["🇦🇺","🇦🇲","🇧🇷","🇧🇮","🇨🇳","🇺🇸","🇨🇿","🇱🇨","🇯🇵","🇷🇺"])
        emojiSets.append(["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑","🚜","🚛","🚒","🚐","🚚"])
        
        let theme : [String] = emojiSets[Int.random(in: 0..<emojiSets.count)]
            
        return theme
    }
}

extension Int {
    var randomNumber: Int {
        if self > 0 {
            return Int.random(in: 0..<self)
        }
        else if self < 0 {
            return -Int.random(in: 0..<abs(self))
        }
        else  {
            return 0
        }
    }
}

