//
//  ARAssetsViewController.swift
//  Tablas201711
//
//  Created by Mac on 31/10/18.
//  Copyright © 2018 Tec de Monterrey. All rights reserved.
//

import UIKit
import SceneKit
import ARKit



class ARAssetsViewController: UIViewController, ARSCNViewDelegate {
    
    var nodoRaiz = SCNNode()
    var currentAngleY: Float = 0.0
    var uurl:String=""
    let mygroup = DispatchGroup()
    var activityIndicator = UIActivityIndicatorView()

    @IBAction func escalar(_ sender: UIPinchGestureRecognizer) {
         nodoRaiz.scale = SCNVector3(sender.scale, sender.scale, sender.scale)
    }
    
    @IBAction func rotate(_ sender: UIRotationGestureRecognizer) {
          nodoRaiz.eulerAngles = SCNVector3(sender.rotation,sender.rotation,0)
    }
    @IBAction func rotar(_ sender: UIPanGestureRecognizer) {
        
       // nodoRaiz.eulerAngles = SCNVector3(sender.translation(in: sender.view!).x,sender.translation(in: sender.view!).y,0)
    }
    @IBOutlet var sceneView: ARSCNView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sceneView.delegate = self
        sceneView.showsStatistics = true
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = view.bounds
        self.activityIndicator.hidesWhenStopped = true
        
        view.addSubview(self.activityIndicator)
        
        let urlAsset = URL(string: uurl)
        let data = try? Data(contentsOf: urlAsset!)
        //let urlMaterial = URL(string: "https://images.all-free-download.com/images/graphiclarge/metal_texture_set_04_hd_picture_170836.jpg")
        //let dataMaterial = try? Data(contentsOf: urlMaterial!)
       downloadpic()
        
        let scene = SCNScene()
        if let filePath = data {
            // ReferenceNode path -> ReferenceNode URL
            let referenceURL = urlAsset
            // Create reference node
            let referenceNode = SCNReferenceNode(url: referenceURL!)
            referenceNode?.load()
            nodoRaiz = referenceNode!
        }
        
       
        //nodoRaiz  "art.scnassets/pug.dae")!
        let materialAsset = SCNMaterial()
        
        materialAsset.diffuse.contents = UIImage(named:"metalrexture.jpg")
        
        nodoRaiz.geometry?.materials = [materialAsset]
        
        nodoRaiz.position = SCNVector3(x:0, y:0, z:-0.4)
        
        scene.rootNode.addChildNode(nodoRaiz)
        // Set the scene to the view
        sceneView.scene = scene
        
        let rotateGestureRecognizer = UIRotationGestureRecognizer (target: self, action: #selector(rotate))
        
        sceneView.addGestureRecognizer(rotateGestureRecognizer)
        
        
    }
    func downloadpic() {
        let catPictureURL = URL(string: "https://images.all-free-download.com/images/graphiclarge/metal_texture_set_04_hd_picture_170836.jpg")!
        
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
                            
                            // Do something with your image.
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
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

}
