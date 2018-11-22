//
//  PanoramicViewController.swift
//  Tablas201711
//
//  Created by LV on 10/29/18.
//  Copyright © 2018 Tec de Monterrey. All rights reserved.
//

import UIKit

class PanoramicViewController: UIViewController {
    
    @IBOutlet weak var panoramaView: CTPanoramaView!
    let panoramicView = CTPanoramaView()
    var uurl:String=""
    var url:String=""
    let mygroup = DispatchGroup()
    var activityIndicator = UIActivityIndicatorView()
    var imageToSave: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(uurl)
        
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor=#colorLiteral(red: 0.9490323663, green: 0.942004025, blue: 0.9544109702, alpha: 1)
        self.activityIndicator.hidesWhenStopped = true
        
        view.addSubview(self.activityIndicator)
        
        
        panoramaView.controlMethod = .motion
        downloadpic()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func downloadpic() {
        let catPictureURL = URL(string: uurl)!
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        
        self.activityIndicator.startAnimating()
        print("animacion")
        
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    // put loading screen here
                    
                    self.mygroup.enter()
                    print("downloading image")
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let data = data {
                        DispatchQueue.main.async {
                            // Finally convert that Data into an image and do what you wish with it.
                            let dataIMG = try? Data(contentsOf: catPictureURL)
                            let image = UIImage(data: dataIMG!)
                            self.mygroup.leave()
                            print("image already downloaded")
                            self.activityIndicator.stopAnimating()
                            self.panoramaView.image = image
                            // Do something with your image.
                            self.imageToSave = image
                        }
                        
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
    }
    
}
