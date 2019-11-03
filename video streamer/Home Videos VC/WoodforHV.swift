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

class WoodfordHV: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var collectionHv: UITableView!
    
    let urlString = "http://homevideosdata.192.168.1.71.xip.io/getClasses.php"
    
    var flix = [Courses]()
    
    var isIt: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchJSON()
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
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    self.flix = try decoder.decode([Courses].self, from: data)
                    self.collectionHv.reloadData()
                    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let sweet = flix[indexPath.row]
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.black
        cell.selectedBackgroundView = bgColorView
        
        cell.titleLbl.text = sweet.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let selectedCell = flix[indexPath.row].location
//        
//        let url = selectedCell!
//        
//        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
//        let player = AVPlayer(url: URL(string: url)!)
//        
//        // Create a new AVPlayerViewController and pass it a reference to the player.
//        let controller = AVPlayerViewController()
//        controller.player = player
//        
//        // Modally present the player and call the player's play() method when complete.
//        present(controller, animated: true) {
//            player.play()
//            
//        }
    }
}



