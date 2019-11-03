  
//
//  VideoPlayer.swift
//  video streamer
//
//  Created by Connor Woodford on 10/31/19.
//  Copyright © 2019 Connor Woodford. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

struct Reader: Codable{
    let err: Dictionary<String, String>?
}

class VideoPlayer: UIViewController {

    
    @IBOutlet weak var videoView: UIView!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var obj: Courses!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            obj.fileformat = ".m3u8"
            obj.browser = "Safari"

            let dictToJson = try! JSONSerialization.data(withJSONObject: obj.json, options: [])

            guard let url = URL(string: "http://192.168.1.19:4012/api/mov/pullvideo") else { return }
            var request = URLRequest(url: url)

            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            
            request.httpBody = dictToJson

            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                 print("Your response: ", response, data, error)
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let mydecode = try decoder.decode(Reader.self, from: data)
                  
                        let urlStr = String(mydecode.err!["location"]!)
                        let url = URL(string: urlStr)
                        
                        if(mydecode.err!["location"] != nil) {
                            print(url!)
                            DispatchQueue.main.async {
                                self.player = AVPlayer(url: url!)
                                
                                self.playerLayer = AVPlayerLayer(player: self.player)
                                
                                self.playerLayer.videoGravity = .resize
                                self.videoView.layer.addSublayer(self.playerLayer)
                                self.playerLayer.frame = self.videoView.bounds
                                
                                self.player.play()
                            }
                        }
                    } catch let jsonErr {
                        print("Failed to decode JSON", jsonErr)
                    }
                }
            }.resume()
        } catch {

        }
    }
    @IBAction func playBtn(_ sender: Any) {
        if(self.player.rate != 0) {
        self.player.pause()
    } else {
        self.player.play()
        }
    }
  }
