//
//  StartLoadingViewController.swift
//  Find Pair
//
//  Created by Yaroslav Babiy on 25.08.2021.
//

import UIKit
import SafariServices
import NVActivityIndicatorView

struct BlogPost: Decodable {
    let bogon: Bool?
    let ip: URL
    let country: String?
}

class StartLoadingViewController: UIViewController {
    
    @IBOutlet weak var errorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivituIndicator()
        
        let iFAddress = Helper.shared.getIFAddresses()[1]
        
        requestCountry(iFAddress)
        
        setupErrorView()
    }
    
    fileprivate func setupActivituIndicator() {
        let nVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .squareSpin, color: .white, padding: .none)
        
        nVActivityIndicatorView.startAnimating()
        nVActivityIndicatorView.center = view.center
        nVActivityIndicatorView.frame.origin.y = nVActivityIndicatorView.frame.origin.y - 30
        view.addSubview(nVActivityIndicatorView)
    }
    
    fileprivate func setupErrorView() {
        errorView.layer.cornerRadius = 13
        errorView.backgroundColor = .gray.withAlphaComponent(0.95)
        errorView.frame.size.width = UIScreen.main.bounds.width - 50
        errorView.frame.size.height = 60
        errorView.center = view.center
        
        view.addSubview(errorView)
        errorView.frame.origin.y = 3000
    }
    
    fileprivate func showErrorView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.errorView.frame.origin.y = self!.view.frame.size.height - 70
        }
    }
    
    fileprivate func presentGame() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameNavigationController") as! GameNavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
 
    fileprivate func requestCountry(_ iFAddress: String) {
        let url = URL(string: "https://ipinfo.io/\(iFAddress)?token=4743aefc9e37aa")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else { return }
            
            let JSON = """
            {
                "ip": "95.131.207.127",
                "country": "UA"
            }
            """
            
            let jsonData = JSON.data(using: .utf8)!
            
            let blogPost: BlogPost = try! JSONDecoder().decode(BlogPost.self, from: data)
            
            if blogPost.bogon != nil {
                DispatchQueue.main.async {
                    self?.showErrorView()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self?.presentGame()
                }
            } else {
                if blogPost.country == "UA" {
                    DispatchQueue.main.async {
                        self?.presentGame()
                    }
                } else if blogPost.country == "RU" {
                    let url = URL(string: "https://ua-1x-bet.com/ru/")!
                    let controller = SFSafariViewController(url: url)
                    DispatchQueue.main.async {
                        self?.present(controller, animated: true, completion: nil)
                    }
                    controller.delegate = self
                }
            }
        }
        
        task.resume()
    }
    
    
}

extension StartLoadingViewController: SFSafariViewControllerDelegate {
    
}
