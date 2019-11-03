//
//  SelectedCell.swift
//  video streamer
//
//  Created by Connor Woodford on 10/20/19.
//  Copyright © 2019 Connor Woodford. All rights reserved.
//

import UIKit


class SelectedCell: UIViewController {
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var overView: UITextView!
    
    @IBOutlet weak var titleLbl: UITextField!
    
    @IBOutlet weak var resolution: UITextField!
    
    var imageUrl = ""
    var obj: Courses!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageUrl = obj.backdropPhotoUrl!
        overView.text = obj.overview
        titleLbl.text = obj.title
        resolution.text = "resolution: " + obj.resolution!
        
        let url = URL(string: imageUrl)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
        if error != nil {
            print(error)
            return
        }
        DispatchQueue.main.async {
            self.moviePoster.image = UIImage(data: data!)
        }
        }).resume()
        
    }
    
    @IBAction func playbtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "video streamer", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "VideoPlayer") as? VideoPlayer
         
        controller?.obj = obj
        
         
        self.present(controller!, animated: true, completion: nil)
        
        
    }
}
