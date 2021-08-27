//
//  GameViewController.swift
//  Find Pair
//
//  Created by Yaroslav Babiy on 25.08.2021.
//

import UIKit
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var levelsTableView: UITableView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var innerPremiumView: UIView!
    @IBOutlet weak var premiumImageView: UIImageView!
    @IBOutlet weak var premiumTitleLabel: UILabel!
    @IBOutlet weak var premiumDetailInfoLabel: UILabel!
    @IBOutlet weak var buyCategoryPremiumButton: UIButton!
    @IBOutlet weak var buyHideAdPremiumButton: UIButton!
    @IBOutlet weak var cancelPremiumButton: UIButton!
    
    let categories = Categories()
    var levels = [GameLevel]()
    var arrAvailableLevelsIDs = [1]
    
    var preferredCategory: Category?
    var selectedCategory: CategoryNames = .Animals
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkDefCategory()
        
        setupTableView()
        
        setupUI()
        
        configureInitialNavigationBar(rootVc: self)
        
        setupCategoriesCollection()
        
        setupBanner()
        
        configurePremiumView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCurrentAvailableLevelsIDs()
    }
    
    fileprivate func checkDefCategory() {
        for (i, cat) in categories.categories.enumerated() {
            if cat.name == selectedCategory {
                categories.categories[i].isMarked = true
            }
        }
    }
    
    func setupCurrentAvailableLevelsIDs() {
        let defaults = UserDefaults.standard
        
        levels = GameLevels.getLevelsByCategory(name: selectedCategory)
        
        arrAvailableLevelsIDs = defaults.array(forKey: GameLevels.getLevelsKey(name: selectedCategory))  as? [Int] ?? [1]
        levelsTableView.reloadData()
    }
    
    fileprivate func configurePremiumView() {
        
        innerPremiumView.backgroundColor = #colorLiteral(red: 0.1058658436, green: 0.105891861, blue: 0.1058642045, alpha: 1).withAlphaComponent(0.98)
        innerPremiumView.layer.cornerRadius = 15
        
        premiumView.tag = 466
        premiumView.backgroundColor = .black.withAlphaComponent(0.4)
        premiumView.alpha = 0
        view.addSubview(premiumView)
    }
    
    fileprivate func setupBanner() {
        if UserDefaults.standard.value(forKey: "isHiddenAd") == nil {
            banner.rootViewController = self
            view.addSubview(banner)
        }
    }
    
    fileprivate func fadeInHideAdView() {
        
        premiumImageView.image = UIImage(named: "hideAds")
        premiumTitleLabel.text = "Hide Ad"
        premiumDetailInfoLabel.text = "After making this purchase, you will permanently disable ads in this program."
        buyCategoryPremiumButton.isHidden = true
        buyHideAdPremiumButton.isHidden = false
        
        fadeInPremView()
    }
    
    fileprivate func fadeInBuyCategoryView() {
        
        premiumImageView.image = UIImage(named: "unlock")
        premiumTitleLabel.text = "Buy Category"
        premiumDetailInfoLabel.text = "After making this purchase, you will get access to this category."
        buyCategoryPremiumButton.isHidden = false
        buyHideAdPremiumButton.isHidden = true
        fadeInPremView()
    }
    
    fileprivate func fadeInPremView() {
        premiumView.frame.origin.y = 0
        premiumView.frame.origin.x = 0
        premiumView.frame.size.height = UIScreen.main.bounds.height
        premiumView.frame.size.width = UIScreen.main.bounds.width
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.premiumView.alpha = 1
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 50, width: UIScreen.main.bounds.width, height: 50)
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .black
        
        cancelPremiumButton.layer.cornerRadius = 10
        buyHideAdPremiumButton.layer.cornerRadius = 10
        buyCategoryPremiumButton.layer.cornerRadius = 10
        cancelPremiumButton.backgroundColor = .gray
        buyHideAdPremiumButton.backgroundColor = .purple
        buyCategoryPremiumButton.backgroundColor = .orange
    }
    
    @IBAction func buyHideAdTapped(_ sender: UIButton) {
        UserDefaults.standard.setValue("1", forKey: "isHiddenAd")
        banner.isHidden = true
        tableViewBottom.constant = 0
        levelsTableView.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.premiumView.alpha = 0
        }
    }
    
    @IBAction func buyCategoryTapped(_ sender: UIButton) {
        if preferredCategory != nil {
            let defaults = UserDefaults.standard
            var arr = defaults.array(forKey: "availableCategories")  as? [Int] ?? [1]
            
            let key = GameLevels.getLevelsKey(name: preferredCategory!.name)
            defaults.set([1], forKey: key)
            
            arr.append(preferredCategory!.id)
            defaults.set(arr, forKey: "availableCategories")
            
            for (i, item) in categories.categories.enumerated() {
                if item.id == preferredCategory!.id {
                    categories.categories[i].isAvailable = true
                }
            }
            
            categories.sortCategories()
            
            categoriesCollectionView.reloadData()
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.premiumView.alpha = 0
            }
        }
    }
    
    @IBAction func closePremiumViewTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.premiumView.alpha = 0
        }
    }
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate func setupCategoriesCollection() {
        
        self.categoriesCollectionView.register(UINib(nibName: CategoryCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        cell.configure(with: categories.categories[indexPath.item], selectedCategory: selectedCategory)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !categories.categories[indexPath.item].isAvailable {
            preferredCategory = categories.categories[indexPath.item]
            fadeInBuyCategoryView()
        } else {
            checkCategory(indexPath: indexPath)
        }
    }
    
    fileprivate func checkCategory(indexPath: IndexPath) {
        if !categories.categories[indexPath.item].isMarked {
            categoriesCollectionView.deselectItem(at: indexPath, animated: true)
            guard let cell = categoriesCollectionView.cellForItem(at: indexPath) as? CategoryCell else { return }
            var category = categories.categories[indexPath.item]
            
            for (index, ln) in categories.categories.enumerated() {
                if ln.isMarked {
                    
                    categories.categories[index].isMarked = false
                    let temp = categories.categories[index]
                    categoriesCollectionView.deselectItem(at: IndexPath(item: index, section: 0), animated: true)
                    categories.categories.remove(at: index)
                    categories.categories.insert(temp, at: index)
                    
                    if let cell = categoriesCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CategoryCell {
                        cell.lockImage.isHidden = true
                    }
                }
            }
            
            selectedCategory = categories.categories[indexPath.item].name
            setupCurrentAvailableLevelsIDs()
            
            category.isMarked = !category.isMarked
            categories.categories.remove(at: indexPath.item)
            categories.categories.insert(category, at: indexPath.item)
            
            DispatchQueue.main.async {
                cell.lockImage.image = UIImage(named: "check_white")
            }
            cell.lockImage.isHidden = category.isMarked == true ? false : true
        } else {
            categoriesCollectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 130)
    }
}

extension GameViewController {
    
    func configureInitialNavigationBar(rootVc: UIViewController) {
        
        rootVc.navigationController?.navigationBar.barStyle = .black
        rootVc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        rootVc.navigationController?.navigationBar.shadowImage = UIImage()
        
        configureInitialRightBarButtonItem(rootVc: rootVc)
    }
    
    func configureInitialRightBarButtonItem(rootVc: UIViewController) {
        
        let isHiddenAd = UserDefaults.standard.value(forKey: "isHiddenAd")
        
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        
        if isHiddenAd != nil {
            menuBtn.setImage(UIImage(named:"hideAds_actived")!, for: .normal)
        } else {
            menuBtn.setImage(UIImage(named:"hideAds")!, for: .normal)
            menuBtn.addTarget(self, action: #selector(hideAds), for: UIControl.Event.touchUpInside)
        }
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        rootVc.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    @objc func hideAds(){
        fadeInHideAdView()
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        levelsTableView.separatorColor = .clear
        levelsTableView.backgroundColor = .black
        
        levelsTableView.register(UINib(nibName: LevelCell.identifier, bundle: nil), forCellReuseIdentifier: LevelCell.identifier)
        levelsTableView.delegate = self
        levelsTableView.dataSource = self
        levelsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LevelCell.identifier, for: indexPath) as! LevelCell
        cell.config(gameLevel: levels[indexPath.item], arrAvailableLevelsIDs: arrAvailableLevelsIDs)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrAvailableLevelsIDs.firstIndex(of: levels[indexPath.item].id) != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlaygroundViewController") as! PlaygroundViewController
            vc.gameLevel = levels[indexPath.item]
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}
