//
//  CategoriesModel.swift
//  Find Pair
//
//  Created by Yaroslav Babiy on 25.08.2021.
//

import Foundation
import UIKit

struct Category {
    let id: Int
    let nameText: String
    let name: CategoryNames
    let image: UIImage
    var isAvailable: Bool
    var isMarked: Bool
}

enum CategoryNames {
    case Animals
    case Sport
    case FoodAndDrink
    case Cars
}

class Categories {
    
    static func getCategory(id: Int) -> Category {
        
        switch id {
        case 1:
            return Category(id: 1, nameText: "Animals", name: .Animals, image: UIImage(named: "animals_cat")!, isAvailable: false, isMarked: false)
        case 2:
            return Category(id: 2, nameText: "Cars", name: .Cars, image: UIImage(named: "cars_cat")!, isAvailable: false, isMarked: false)
        case 3:
            return Category(id: 3, nameText: "Sport", name: .Sport, image: UIImage(named: "Sport")!, isAvailable: false, isMarked: false)
        default:
            return Category(id: 4, nameText: "Food & Drink", name: .FoodAndDrink, image: UIImage(named: "food_and_drink_cat")!, isAvailable: false, isMarked: false)
        }
    }
    
    var categories = [Category]()
    init() {
        setup()
    }
    func setup(){
    
        categories = [Categories.getCategory(id: 1), Categories.getCategory(id: 2), Categories.getCategory(id: 3), Categories.getCategory(id: 4)]
        
        let arrAvailableCategoriesIDs = getArrAvailableCategoriesIDs()
        
        for (i, category) in categories.enumerated() {
            if (arrAvailableCategoriesIDs.firstIndex(of: category.id) != nil) {
                categories[i].isAvailable = true
            } else {
                categories[i].isAvailable = false
            }
        }
        
        sortCategories()
    }
    
    func sortCategories() {
        var allowedCatgs = [Category]()
        var notAllowedCatgs = [Category]()
        
        let defaults = UserDefaults.standard
        let arr = defaults.array(forKey: "availableCategories")  as? [Int] ?? [1]
        for cat in categories {
            if arr.firstIndex(of: cat.id) != nil {
                allowedCatgs.append(cat)
            } else {
                notAllowedCatgs.append(cat)
            }
        }
        
        categories = allowedCatgs
        
        for notAllowedCatg in notAllowedCatgs {
            categories.append(notAllowedCatg)
        }
    }
    
    func getArrAvailableCategoriesIDs() -> [Int] {
        let defaults = UserDefaults.standard
        return defaults.array(forKey: "availableCategories")  as? [Int] ?? [1]
    }
}
