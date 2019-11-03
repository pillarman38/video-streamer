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

class TVStuffViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate {
    @IBOutlet weak var collections: UICollectionView!

    let urlString = "http://192.168.1.7:4012/api/photos/getTvShows"

    var flix = [Courses]()

    var isIt: Bool!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(fetchJSON), for: .valueChanged)
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collections.refreshControl = refresher
        
        fetchJSON()
        
    }
    @objc func saveFavs(notification: Notification) {
        
    }

    
    @objc func dissmiss(notification: Notification) {
        dismiss(animated: true, completion: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = collections.indexPathsForSelectedItems?.first
            if segue.identifier == "selectedShow" {
                let vc = segue.destination as! TVShowVC
                vc.urlString = flix[(indexPath?.row)!].location!
            }
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
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    self.flix = try decoder.decode([Courses].self, from: data)
                    self.collections.reloadData()
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
        
        if let profileImageUrl = sweet.poster_path {
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
//        let selectedCell = flix[indexPath.row]
//        
//        let url = selectedCell.location
//      
//        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
//    
//        let anotherVC = TVShowVC()
//        // Create a new AVPlayerViewController and pass it a reference to the player.
//   
//        performSegue(withIdentifier: "selectedShow", sender: self)
//        
//        // Modally present the player and call the player's play() method when complete.
        
    }
}


