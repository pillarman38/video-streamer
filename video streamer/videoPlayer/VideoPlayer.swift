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
                                var player = AVPlayer(url: url!)
                                var playerLayer: AVPlayerLayer!
                                
                                playerLayer = AVPlayerLayer(player: player)
                                
                                playerLayer.videoGravity = .resize
                                self.videoView.layer.addSublayer(playerLayer)
                                playerLayer.frame = self.videoView.bounds
                                player.play()
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
}
