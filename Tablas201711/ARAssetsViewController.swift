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
import Vision


class ARAssetsViewController: UIViewController, ARSCNViewDelegate {
    
    private var hitTestResult: ARHitTestResult!
    private var resnetModel = Resnet50()
    private var visionRequests = [VNRequest]()
    //1. cargar el modelo de la red
    //2. registrar el gesto de tap
    //3. instanciar el modelo y enviar la imagen
    //4. Presentar los datos resultados del modelo
    
    
    @IBAction func tapEjecutado(_ sender: UITapGestureRecognizer) {
    
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
        
        /*
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        */
 
        //
        // Agrega el modelo de la URL a la vista
        //
 
 
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
    
    @objc func doubleTapped() {
        sceneView.scene.rootNode.enumerateChildNodes {(node,stop) in node.removeFromParentNode()}
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
        //letrero.alignmentMode = kCAAlignmentCenter
        letrero.firstMaterial?.diffuse.contents = UIColor.blue
        letrero.firstMaterial?.specular.contents = UIColor.white
        letrero.firstMaterial?.isDoubleSided = true
        letrero.font = UIFont(name: "Futura", size: 0.20)
        let nodo = SCNNode(geometry: letrero)
        nodo.position = SCNVector3(self.hitTestResult.worldTransform.columns.3.x,self.hitTestResult.worldTransform.columns.3.y-0.2,self.hitTestResult.worldTransform.columns.3.z )
        nodo.scale = SCNVector3Make(0.2, 0.2, 0.2)
        self.sceneView.scene.rootNode.addChildNode(nodo)
        
        
        
        
    }

}
