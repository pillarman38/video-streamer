//
//  SearchTableViewController.swift
//  ugggh
//
//  Created by Connor Woodford on 12/21/18.
//  Copyright © 2018 Connor Woodford. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SearchTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var collection: UITableView!
    
    var isSearching = false;
    
    let urlString = "http://homevideosdata.192.168.1.7.xip.io/getMoreClasses.php"
    
    let urlStringTwo = "http://homevideosdata.192.168.1.71.xip.io/getClasses.php"
    
    var flix = [Courses]()
    
    var searchArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJSON()
        fetchJSONAgain()
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
                    self.collection.reloadData()
                    
                } catch let jsonErr {
                    print("Failed to decode JSON", jsonErr)
                }
            }
            }.resume()
        let deadline = DispatchTime.now() + .microseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline){
           
        }
    }
    @objc func fetchJSONAgain() {
        guard let url = URL(string: urlStringTwo) else { return }
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
                    self.collection.reloadData()
                    
                } catch let jsonErr {
                    print("Failed to decode JSON", jsonErr)
                }
            }
            }.resume()
        let deadline = DispatchTime.now() + .microseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline){
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return flix.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTVCell
        
        let sweet = flix[indexPath.row].title
    
        cell.searchLbl.text = sweet
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = flix[indexPath.row].location
        
        let url = selectedCell
        
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

