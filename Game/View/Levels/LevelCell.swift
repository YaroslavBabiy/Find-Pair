//
//  LevelCell.swift
//  Find Pair
//
//  Created by Yaroslav Babiy on 26.08.2021.
//

import UIKit

class LevelCell: UITableViewCell {

    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "LevelCell"
    
    static func nib()-> UINib{
        return UINib(nibName: LevelCell.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lockImageView.alpha = 0.8
        self.selectionStyle = .none
    }
    
    func config(gameLevel: GameLevel, arrAvailableLevelsIDs: [Int]) {
        titleLabel.text = gameLevel.nameText
        
        if arrAvailableLevelsIDs.firstIndex(of: gameLevel.id) == nil {
            lockImageView.isHidden = false
        } else {
            lockImageView.isHidden = true
        }
        
        wrapView.layoutIfNeeded()
        wrapView.addBottomBorderWithColor(color: UtilColors.horisontalLineColor, width: 1)
    }
}
