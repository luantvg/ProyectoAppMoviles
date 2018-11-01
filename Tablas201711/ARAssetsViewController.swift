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

    @IBAction func escalar(_ sender: UIPinchGestureRecognizer) {
         nodoRaiz.scale = SCNVector3(sender.scale, sender.scale, sender.scale)
    }
    
    @IBAction func rotate(_ sender: UIRotationGestureRecognizer) {
          nodoRaiz.eulerAngles = SCNVector3(0,sender.rotation,0)
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
        
        let urlAsset = URL(string: "http://martinmolina.com.mx/201813/scenes/pug.scn")
        let data = try? Data(contentsOf: urlAsset!)
       
        
        let scene = SCNScene()
        if let filePath = data {
            // ReferenceNode path -> ReferenceNode URL
            let referenceURL = urlAsset
            // Create reference node
            let referenceNode = SCNReferenceNode(url: referenceURL!)
            referenceNode?.load()
            nodoRaiz = referenceNode!
        }
        
        let urlMaterial = URL(string: "http://martinmolina.com.mx/201813/scenes/pug-texture.jpg")
        let dataMaterial = try? Data(contentsOf: urlMaterial!)
        //nodoRaiz  "art.scnassets/pug.dae")!
        let materialAsset = SCNMaterial()
        
        materialAsset.diffuse.contents =  UIImage(data: dataMaterial!)
        
        nodoRaiz.geometry?.materials = [materialAsset]
        
        nodoRaiz.position = SCNVector3(x:0, y:0, z:-0.4)
        
        scene.rootNode.addChildNode(nodoRaiz)
        // Set the scene to the view
        sceneView.scene = scene
        
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
