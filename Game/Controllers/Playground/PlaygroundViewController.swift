//
//  PlaygroundViewController.swift
//  Find Pair
//
//  Created by Yaroslav Babiy on 26.08.2021.
//

import UIKit
import GoogleMobileAds

class PlaygroundViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var topBarTopSpace: NSLayoutConstraint!
    
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    
    var gameLevel: GameLevel!
    var pairOfCards = [Card]()
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    
    override var prefersStatusBarHidden: Bool {
        if Helper.shared.hasTopNotch {
            return false
        } else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        setupCategoriesCollection()
        
        setupBanner()
    }
    
    fileprivate func setupUI() {
        levelLabel.text = gameLevel.nameText
    }
    
    fileprivate func setupBanner() {
        if UserDefaults.standard.value(forKey: "isHiddenAd") == nil {
            banner.rootViewController = self
            view.addSubview(banner)
        } else {
            topBarTopSpace.constant = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let topBar = levelLabel.superview!
        banner.frame = CGRect(x: 0, y: topBar.frame.origin.y - 50, width: UIScreen.main.bounds.width, height: 50)
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PlaygroundViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate func setupCategoriesCollection() {
        
        if !Helper.shared.hasTopNotch {
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.layoutIfNeeded()
        }

        var hDif: CGFloat = 12
        if UserDefaults.standard.value(forKey: "isHiddenAd") != nil {
            hDif = -1
        }
        
        cellHeight = (collectionView.frame.size.height / gameLevel.numberOfRows) - hDif
        cellWidth = (self.view.frame.size.width / gameLevel.numberOfColumns) - 12
        
        self.collectionView.register(UINib(nibName: PlaygroundCell.identifier, bundle: nil), forCellWithReuseIdentifier: PlaygroundCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameLevel.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaygroundCell.identifier, for: indexPath) as! PlaygroundCell
        
        cell.isFlipped = false
        cell.frame.size.width = cellWidth
        cell.frame.size.height = cellHeight
        
        cell.backImageView.image = UIImage()
        cell.backImageView.alpha = 1
        cell.backImageView.backgroundColor = gameLevel.cardColor
        return cell
    }
    
    
    func backCell(cell: PlaygroundCell, indexPath: IndexPath) {
        let image = gameLevel.cards[indexPath.item].imageBack
        DispatchQueue.main.async {
            cell.backImageView.image = image
        }

        cell.backImageView.backgroundColor = .white
        UIView.transition(with: cell.backImageView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
        cell.isFlipped = true
    }
    
    func faceCell(cell: PlaygroundCell) {
        let image = UIImage()
        DispatchQueue.main.async {
            cell.backImageView.image = image
        }
        cell.backImageView.backgroundColor = gameLevel.cardColor
        UIView.transition(with: cell.backImageView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
        cell.isFlipped = false
    }
    
    func showCompletedGameAlert() {
        let alert = UIAlertController(title: "Game completed!", message: "Congratulations, you have completed all the levels!", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Menu", style: UIAlertAction.Style.cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCompletedLevelAlert() {
        let alert = UIAlertController(title: "Level completed!", message: "Would you like to advance to the next level?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: { [weak self] action in
            
            self?.cellHeight = (self!.collectionView.frame.size.height / self!.gameLevel.numberOfRows) - 11
            self?.cellWidth = (self!.view.frame.size.width / self!.gameLevel.numberOfColumns) - 12
            self?.levelLabel.text = self?.gameLevel.nameText
            
            self!.collectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Menu", style: UIAlertAction.Style.cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func upLevel() {
        let defaults = UserDefaults.standard
        let key = GameLevels.getLevelsKey(name: gameLevel.category)
        var arr = defaults.array(forKey: key)  as? [Int] ?? [1]
        arr.append(gameLevel.id)
        defaults.set(arr, forKey: key)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? PlaygroundCell else { return }
        
        if pairOfCards.count < 2 {
            if !cell.isFlipped {
                
                pairOfCards.append(gameLevel.cards[indexPath.item])
                
                backCell(cell: cell, indexPath: indexPath)
                
                if pairOfCards.count == 2 {
                    
                    if let cell1 = collectionView.cellForItem(at: IndexPath(item: pairOfCards[0].id, section: 0)) as? PlaygroundCell, let cell2 = collectionView.cellForItem(at: IndexPath(item: pairOfCards[1].id, section: 0)) as? PlaygroundCell {
                        if pairOfCards[0].pairedId == pairOfCards[1].pairedId {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                                
                                self?.gameLevel.cards[self!.pairOfCards[0].id].isHidden = true
                                self?.gameLevel.cards[self!.pairOfCards[1].id].isHidden = true
                                cell1.fadeOutCell()
                                cell2.fadeOutCell()
                                self?.pairOfCards.removeAll()
                                
                                for card in self!.gameLevel.cards {
                                    if !card.isHidden {
                                        return
                                    }
                                }
                                
                                if self!.gameLevel.id == 6 {
                                    self?.showCompletedGameAlert()
                                } else {
                                    self!.gameLevel = GameLevels.getLevelById(id: self!.gameLevel.id + 1, name: self!.gameLevel.category)
                                    self?.showCompletedLevelAlert()
                                }
                                
                                self?.upLevel()
                            }
                        } else {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                                self?.faceCell(cell: cell1)
                                self?.faceCell(cell: cell2)
                                self?.pairOfCards.removeAll()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension PlaygroundViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
