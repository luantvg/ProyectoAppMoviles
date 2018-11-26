//
//  PortalViewController.swift
//  Tablas201711
//
//  Created by cdt307 on 11/7/18.
//  Copyright © 2018 Tec de Monterrey. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision

class PortalViewController: UIViewController , ARSCNViewDelegate {
    
    var idsalon:String=""
    var imgUrl:String=""
    //Machine Learning
    private var hitTestResult: ARHitTestResult!
    private var resnetModel = Resnet50()
    private var visionRequests = [VNRequest]()
     @IBOutlet weak var sceneView: ARSCNView!
    //1. cargar el modelo de la red
    //2. registrar el gesto de tap
    //3. instanciar el modelo y enviar la imagen
    //4. Presentar los datos resultados del modelo
    
    //Portal
    
    @IBOutlet weak var planeDetected: UILabel!
    let configuration = ARWorldTrackingConfiguration()
    
    @objc func tapDone(sender: UITapGestureRecognizer) {
        print("tap")
        guard let sceneView = sender.view as? ARSCNView else {return}
        let touchLocation = sender.location(in: sceneView)
        //obtener los resultados del tap sobre el plano horizontal
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty{
            //cargar la escena
            self.setupScene()
        }
        else{
            // no hubo resultado
        }
    }
    
    func addPortal(hitTestResult:ARHitTestResult)
    {
        //let catPictureURL = URL(string: imgUrl)!
        //let dataIMG = try? Data(contentsOf: catPictureURL)
        //let image = UIImage(data: dataIMG!)
        let portalScene = SCNScene(named:"escenes.sncassets/Portal.scn")
        let portalNode = portalScene?.rootNode.childNode(withName: "Portal", recursively: false)
        //convertir las coordenadas del rayo del tap a coordenadas del mundo real
        let transform = hitTestResult.worldTransform
        let planeXposition = transform.columns.3.x
        let planeYposition = transform.columns.3.y
        let planeZposition = transform.columns.3.z
        portalNode?.position = SCNVector3(planeXposition,planeYposition,planeZposition)
        self.sceneView.scene.rootNode.addChildNode(portalNode!)
        
    }
    
    func setupScene() {
        let node = SCNNode()
        node.position = SCNVector3.init(0, 0, 0)
        
        let leftWall = createBox(isDoor: false, whichSide: "left")
        leftWall.position = SCNVector3.init((-length / 2) + width, 0, -1.4)
        leftWall.eulerAngles = SCNVector3.init(0, 180.0.degreesToRadians, 0)
        
        let rightWall = createBox(isDoor: false, whichSide: "right")
        rightWall.position = SCNVector3.init((length / 2) - width, 0, -1.4)
        
        let topWall = createBox(isDoor: false, whichSide: "top")
        topWall.position = SCNVector3.init(0, (height / 2) - width, -1.4)
        topWall.eulerAngles = SCNVector3.init(90.0.degreesToRadians, 0, 90.0.degreesToRadians)
        
        let bottomWall = createBox(isDoor: false, whichSide: "bottom")
        bottomWall.position = SCNVector3.init(0, (-height / 2) + width, -1.4)
        bottomWall.eulerAngles = SCNVector3.init(-90.0.degreesToRadians, 0, -90.0.degreesToRadians)
        
        let backWall = createBox(isDoor: false, whichSide: "front")
        backWall.position = SCNVector3.init(0, 0, (-length / 2) + width - 1.4)
        backWall.eulerAngles = SCNVector3.init(0, 90.0.degreesToRadians, 0)
        
        let leftDoorSide = createBox(isDoor: true, whichSide: "left")
        leftDoorSide.position = SCNVector3.init((-length / 2 + width) + (doorLength / 2), 0, (length / 2) - width - 1.4)
        leftDoorSide.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        
        let rightDoorSide = createBox(isDoor: true, whichSide: "right")
        rightDoorSide.position = SCNVector3.init((length / 2 - width) - (doorLength / 2), 0, (length / 2) - width - 1.4)
        rightDoorSide.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        
        /*let sphereCool = SCNSphere(radius: width)
         sphereCool.firstMaterial?.diffuse.contents = UIImage(named: "Venice")
         
         let sphereCoolNode = SCNNode(geometry: sphereCool)
         
         sphereCoolNode.position = SCNVector3.init(0,0,0)
         
         self.sceneView.scene.rootNode.addChildNode(sphereCoolNode)*/
        
        //Create Light
        
        
        let light = SCNLight();
        light.type = SCNLight.LightType.omni;
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3.init(0, 0.0, -1.4)
        node.addChildNode(lightNode)
        
        //Adding Nodes to Main Node
        node.addChildNode(leftWall)
        node.addChildNode(rightWall)
        node.addChildNode(topWall)
        node.addChildNode(bottomWall)
        node.addChildNode(backWall)
        node.addChildNode(leftDoorSide)
        node.addChildNode(rightDoorSide)
        
        self.sceneView.scene.rootNode.addChildNode(node)
    }

    
    
    //ML
    
    @objc func doubleTapped(sender: UITapGestureRecognizer){
        print("tap")
        //obtener la vista donde se va a trabajar
        let vista = sender.view as! ARSCNView
        //ubicar el toque en el centro de la vista
        let ubicacionToque = self.sceneView.center
        //obtener la imagen actual
        guard let currentFrame = vista.session.currentFrame else {return}
        //obtener los nodos que fueron tocados por el rayo
        let hitTestResults = vista.hitTest(ubicacionToque, types: .featurePoint)
        
        if (hitTestResults .isEmpty){
            //no se toco nada
            return}
        guard var hitTestResult = hitTestResults.first else{
            return
            
        }
        //obtener la imagen capturada en formato de buffer de pixeles
        let imagenPixeles = currentFrame.capturedImage
        self.hitTestResult = hitTestResult
        performVisionRequest(pixelBuffer: imagenPixeles)
    }
    
    private func performVisionRequest(pixelBuffer: CVPixelBuffer)
    {
        //inicializar el modelo de ML al modelo usado, en este caso resnet
        let visionModel = try! VNCoreMLModel(for: resnetModel.model)
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            
            if error != nil {
                //hubo un error
                return}
            guard let observations = request.results else {
                //no hubo resultados por parte del modelo
                return
                
            }
            //obtener el mejor resultado
            let observation = observations.first as! VNClassificationObservation
            
            print("Nombre \(observation.identifier) confianza \(observation.confidence)")
            self.desplegarTexto(entrada: observation.identifier)
            
        }
        //la imagen que se pasará al modelo sera recortada para quedarse con el centro
        request.imageCropAndScaleOption = .centerCrop
        self.visionRequests = [request]
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .upMirrored, options: [:])
        DispatchQueue.global().async {
            try! imageRequestHandler.perform(self.visionRequests)
            
        }
        
    }
    
    private func desplegarTexto(entrada: String)
    {
        
        let letrero = SCNText(string: entrada
            , extrusionDepth: 0)
        print(letrero)
        letrero.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        letrero.firstMaterial?.diffuse.contents = UIColor.blue
        letrero.firstMaterial?.specular.contents = UIColor.white
        letrero.firstMaterial?.isDoubleSided = true
        letrero.font = UIFont(name: "Futura", size: 0.20)
        let nodo = SCNNode(geometry: letrero)
        nodo.position = SCNVector3(self.hitTestResult.worldTransform.columns.3.x,self.hitTestResult.worldTransform.columns.3.y-0.2,self.hitTestResult.worldTransform.columns.3.z )
        nodo.scale = SCNVector3Make(0.2, 0.2, 0.2)
        self.sceneView.scene.rootNode.addChildNode(nodo)
        
        
        
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapDone))
        tap.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        self.sceneView.addGestureRecognizer(doubleTap)
        
        tap.require(toFail: doubleTap)
        
        print("si entro")
        
        // Set the view's delegate
        //sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene()
        
        // Set the scene to the view
        //sceneView.scene = scene
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }*/
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("rendering")
        guard anchor is ARPlaneAnchor else {return} //se agrego un plano
        //ejecución asincrona en donde se modifica la etiqueta de plano detectado
        DispatchQueue.main.async {
            self.planeDetected.isHidden = false
            print("Plano detectado")
        }
        //espera 3 segundos antes de desaparecer
        DispatchQueue.main.asyncAfter(deadline: .now()+3){self.planeDetected.isHidden = true}
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
