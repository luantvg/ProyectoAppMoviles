//
//  ModeloViewController.swift
//  ProyectoF
//
//  Created by alumnos on 10/24/18.
//  Copyright © 2018 Fafnir. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ModeloViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var isekaiPlane: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    var modelURL:URL?
    let session = URLSession(configuration: .default)
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mostrar el origen y los puntos detectados
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        //indicar la detección del plano
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        //administrador de gestos para identificar el tap sobre el plano horizontal
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.sceneView.addGestureRecognizer(tap)
    }
    
    //función administradora de gestos
    @objc func tapHandler(sender: UITapGestureRecognizer){
        guard let sceneView = sender.view as? ARSCNView else {return}
        let touchLocation = sender.location(in: sceneView)
        //obtener los resultados del tap sobre el plano horizontal
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty{
            //cargar la escena
            self.addPortal(hitTestResult: hitTestResult.first!)
        }
        else{
            // no hubo resultado
        }// UIImage(data: )
        
        
    }
    //cargar el portal
    func addPortal(hitTestResult:ARHitTestResult)
    {
        let imageData = try! Data(contentsOf: modelURL!)
        let urlImage = UIImage(data: imageData)
        let portalScene = SCNScene(named: "art.scnassets/Portal.scn")
        let portalNode = portalScene?.rootNode.childNode(withName: "Portal", recursively: false)
        let sphereNode = portalNode!.childNode(withName: "sphere", recursively: false)
        sphereNode?.geometry?.firstMaterial!.diffuse.contents = urlImage
        let transform = hitTestResult.worldTransform
        let planeXposition = transform.columns.3.x
        let planeYposition = transform.columns.3.y
        let planeZposition = transform.columns.3.z
        portalNode?.position = SCNVector3(planeXposition,planeYposition,planeZposition)
        self.sceneView.scene.rootNode.addChildNode(portalNode!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //esta funcion indica al delegado que se ha agregado un nuevo nodo en la escena
    /* para mayor detalle https://developer.apple.com/documentation/arkit/arscnview/providing_3d_virtual_content_with_scenekit
     */
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return} //se agrego un plano
        //ejecución asincrona en donde se modifica la etiqueta de plano detectado
        DispatchQueue.main.async {
            self.isekaiPlane.isHidden = false
            print("Plano detectado")
        }
        //espera 3 segundos antes de desaparecer
        DispatchQueue.main.asyncAfter(deadline: .now()+3){self.isekaiPlane.isHidden = true}
    }
    
}
