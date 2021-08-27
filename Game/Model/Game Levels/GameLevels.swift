//
//  GameLevels.swift
//  Find Pair
//
//  Created by Yaroslav Babiy on 25.08.2021.
//

import Foundation
import UIKit

struct GameLevel {
    var id: Int
    var cards: [Card]
    let nameText: String
    var cardColor: UIColor
    let numberOfRows: CGFloat
    let numberOfColumns: CGFloat
    let category: CategoryNames
}

struct Card {
    var id: Int
    let imageBack: UIImage
    let isFlipped: Bool
    let pairedId: Int
    var isHidden: Bool
}

class GameLevels {
    private init () {}
    
    static func getLevelsByCategory(name: CategoryNames) -> [GameLevel] {
        return [getLevelById(id: 1, name: name), getLevelById(id: 2, name: name), getLevelById(id: 3, name: name), getLevelById(id: 4, name: name), getLevelById(id: 5, name: name), getLevelById(id: 6, name: name)]
    }
    
    static let animals = [UIImage(named: "icons8-alligator-96"), UIImage(named: "icons8-cat-96"), UIImage(named: "icons8-crab-96"), UIImage(named: "icons8-fat-dog-96"), UIImage(named: "icons8-ladybird-96"), UIImage(named: "icons8-lemur-96"), UIImage(named: "icons8-moose-96"), UIImage(named: "icons8-ordinary-jaguar-96"), UIImage(named: "icons8-panda-96"), UIImage(named: "icons8-prawn-96"), UIImage(named: "icons8-sea-shell-96"), UIImage(named: "icons8-shell-96"), UIImage(named: "icons8-tiger-96"), UIImage(named: "icons8-turkeycock-96"), UIImage(named: "icons8-turtle-96")]
    
    static let cars = [UIImage(named: "icons8-airplane-take-off-96"), UIImage(named: "icons8-container-truck-96"), UIImage(named: "icons8-dirigible-96"), UIImage(named: "icons8-engine-oil-96"), UIImage(named: "icons8-gas-station-96"), UIImage(named: "icons8-helicopter-96"), UIImage(named: "icons8-historic-ship-96"), UIImage(named: "icons8-launch-96"), UIImage(named: "icons8-motorcycle-96"), UIImage(named: "icons8-old-car-96"), UIImage(named: "icons8-steam-engine-96"), UIImage(named: "icons8-submarine-96"), UIImage(named: "icons8-taxi-96"), UIImage(named: "icons8-tow-truck-96"), UIImage(named: "icons8-tractor-96")]
    
    static let food = [UIImage(named: "icons8-apple-jam-96"), UIImage(named: "icons8-blueberry-96"), UIImage(named: "icons8-bread-96"), UIImage(named: "icons8-cheese-96"), UIImage(named: "icons8-cherry-96"), UIImage(named: "icons8-french-fries-96"), UIImage(named: "icons8-gingerbread-house-96"), UIImage(named: "icons8-lemonade-96"), UIImage(named: "icons8-pizza-96"), UIImage(named: "icons8-popcorn-96"), UIImage(named: "icons8-pretzel-96"), UIImage(named: "icons8-raspberry-96"), UIImage(named: "icons8-strawberry-96"), UIImage(named: "icons8-tin-can-96"), UIImage(named: "icons8-watermelon-96")]
    
    static let sport = [UIImage(named: "icons8-basketball-96"), UIImage(named: "icons8-bowling-ball-96"), UIImage(named: "icons8-boxing-96"), UIImage(named: "icons8-energy-drink-96"), UIImage(named: "icons8-hockey-gates-96"), UIImage(named: "icons8-laurel-wreath-96"), UIImage(named: "icons8-medal-first-place-96"), UIImage(named: "icons8-muscle-flexing-96"), UIImage(named: "icons8-parachute-96"), UIImage(named: "icons8-ranners-crossing-finish-line-96"), UIImage(named: "icons8-raquet-96"), UIImage(named: "icons8-rollerblade-96"), UIImage(named: "icons8-ski-goggles-96"), UIImage(named: "icons8-soccer-ball-96"), UIImage(named: "icons8-track-and-field-96")]
    
    static func getLevelById(id: Int, name: CategoryNames) -> GameLevel {
        switch id {
        case 1:
            return GameLevel(id: 1, cards: getNumbersCards(numberOfCards: 16, name: name), nameText: "Level 1", cardColor: .cyan, numberOfRows: 4, numberOfColumns: 4, category: name)
        case 2:
            return GameLevel(id: 2, cards: getNumbersCards(numberOfCards: 18, name: name), nameText: "Level 2", cardColor: .systemYellow, numberOfRows: 6, numberOfColumns: 3, category: name)
        case 3:
            return GameLevel(id: 3, cards: getNumbersCards(numberOfCards: 20, name: name), nameText: "Level 3", cardColor: .systemYellow, numberOfRows: 5, numberOfColumns: 4, category: name)
        case 4:
            return GameLevel(id: 4, cards: getNumbersCards(numberOfCards: 24, name: name), nameText: "Level 4", cardColor: .systemGreen, numberOfRows: 6, numberOfColumns: 4, category: name)
        case 5:
            return GameLevel(id: 5, cards: getNumbersCards(numberOfCards: 28, name: name), nameText: "Level 5", cardColor: .systemOrange, numberOfRows: 7, numberOfColumns: 4, category: name)
        default:
            return GameLevel(id: 6, cards: getNumbersCards(numberOfCards: 30, name: name), nameText: "Level 6", cardColor: .systemIndigo, numberOfRows: 6, numberOfColumns: 5, category: name)
        }
    }
    
    static func getLevelsKey(name: CategoryNames) -> String {
        switch name {
        case .Animals:
            return "availableAnimalsLevels"
        case .Cars:
            return "availableCarsLevels"
        case .Sport:
            return "availableSportLevels"
        default:
            return "availableFoodAndDrinkLevels"
        }
    }
    
    static func getNumbersCards(numberOfCards: Int, name: CategoryNames) -> [Card] {
        
        var arrImages = [UIImage?]()
        if name == .Animals {
            arrImages = animals
        } else if name == .Cars {
            arrImages = cars
        } else if name == .Sport {
            arrImages = sport
        } else {
            arrImages = food
        }
        arrImages.shuffle()
        
        var cards = [Card]()
        
        for index in 0..<numberOfCards / 2 {
            cards.append(Card(id: index, imageBack: arrImages[index]!, isFlipped: false, pairedId: index, isHidden: false))
            cards.append(Card(id: index, imageBack: arrImages[index]!, isFlipped: false, pairedId: index, isHidden: false))
        }
        
        cards.shuffle()
        
        for (i, _) in cards.enumerated() {
            cards[i].id = i
        }
        
        return cards
    }
}
