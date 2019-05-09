//
//  HomePage.swift
//  ugggh
//
//  Created by Connor Woodford on 5/21/18.
//  Copyright © 2018 Connor Woodford. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class TVShowVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var collect: UICollectionView!
    
    var urlString = ""
    
    var flix = [TVTable]()
    
    var isIt: Bool!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        
        refreshControl.addTarget(self, action: #selector(fetchJSON), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collect.refreshControl = refresher
        fetchJSON()
        
    }
    @objc func saveFavs(notification: Notification) {
        
    }

    @objc func checkIt(notification: Notification) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    @objc func dissmiss(notification: Notification) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func fetchJSON() {
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from URL:", err)
                    return
                } else {
                    print("Loaded URL")
                    print(url)
                    
                }
                
                guard let data = data else { return }
                
                
                do {
                    let decoder = JSONDecoder()
                    self.flix = try decoder.decode([TVTable].self, from: data)
                    self.collect.reloadData()
                    print(self.flix)
                } catch let jsonErr {
                    print("Failed to decode JSON", jsonErr)
                }
            }
            }.resume()
        let deadline = DispatchTime.now() + .microseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline){
            self.refresher.endRefreshing()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flix.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TVCell
        
        let sweet = flix[indexPath.row]
        cell.tvLbl.text = sweet.title
        
        if let profileImageUrl = sweet.image {
            let url = URL(string: profileImageUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    cell.tvImg.image = UIImage(data: data!)
                    
                }
            }).resume()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = flix[indexPath.row].loc
        
        let url = selectedCell
        print(selectedCell)
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: URL(string: url)!)
        
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }
    }
}




