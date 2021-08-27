//
//  PlaygroundCell.swift
//  Find Pair
//
//  Created by Yaroslav Babiy on 26.08.2021.
//

import UIKit

class PlaygroundCell: UICollectionViewCell {

    @IBOutlet weak var backImageView: UIImageView!
    
    var isFlipped = false
    
    static let identifier = "PlaygroundCell"
    
    static func nib()-> UINib{
        return UINib(nibName: "PlaygroundCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func fadeOutCell() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.backImageView.alpha = 0
        }
    }
}
