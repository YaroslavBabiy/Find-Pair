//
//  CategoryCell.swift
//  Find Pair
//
//  Created by Yaroslav Babiy on 25.08.2021.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    static let identifier = "CategoryCell"
    
    static func nib()-> UINib{
        return UINib(nibName: "CategoryCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        lockImage.alpha = 0.8
    }
    
    public func configure(with category: Category, selectedCategory: CategoryNames){
        
        if category.name == selectedCategory {
            DispatchQueue.main.async { [weak self] in
                self?.lockImage.image = UIImage(named: "check_white")
            }
            lockImage.isHidden = false
            categoryImage.alpha = 1
        } else {
            if category.isAvailable {
                lockImage.isHidden = true
                categoryImage.alpha = 1
            } else {
                lockImage.isHidden = false
                categoryImage.alpha = 0.4
            }
        }
        self.categoryImage.image = category.image
        self.categoryNameLabel.text = category.nameText
    }
}
