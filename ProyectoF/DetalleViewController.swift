//
//  DetalleViewController.swift
//  ProyectoF
//
//  Created by alumnos on 9/12/18.
//  Copyright © 2018 Fafnir. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController {

    var lab:Any?
    var letContinue:Bool = false
    var letContinueModel:Bool = false
    var destinationFileUrl:URL?
    var ModeldestinationFileUrl:URL?
    var fotosURL:[String]?
    var fotoContrl = -1
    
    @IBOutlet weak var name: UITextView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var trayectoria: UILabel!
    
    @IBOutlet weak var fotosSpin: UIActivityIndicatorView!
    @IBOutlet weak var foto: UIImageView!
    
    @IBOutlet weak var videoSpin: UIActivityIndicatorView!
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var modeloSpin: UIActivityIndicatorView!
    @IBOutlet weak var modeloButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoSpin.startAnimating()
        modeloSpin.startAnimating()
        fotosSpin.isHidden = true
        modeloButton.isEnabled = false
        videoButton.isEnabled = false
        printOnScreen()
        foto.isUserInteractionEnabled = true
        let navFotos = UITapGestureRecognizer(target: self, action: #selector(self.navFotos))
        foto.addGestureRecognizer(navFotos)
    }
    
    func printOnScreen(){
        print(lab! as! [String:Any])
        name.text = (lab! as! [String : Any])["nombre"] as? String
        location.text = (lab! as! [String : Any])["ubicacion"] as? String
        trayectoria.text = (lab! as! [String : Any])["trayectoria"] as? String
        fotosURL = ((lab! as! [String : Any])["imagen"] as? [String])!
        for i in fotosURL! {
            print(i)
        }
        downloadVideo()
        downloadModel()
        navFotos()
    }
    
    @objc func navFotos(){
        if fotoContrl == ((fotosURL?.count)! - 1){
            fotoContrl = 0
        }else{
            fotoContrl+=1
        }
        if let url = URL(string: fotosURL![fotoContrl]){
            fotosSpin.isHidden = true
            fotosSpin.startAnimating()
            downloadImage(from: url)
        }
    }
    
    func downloadModel(){
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        ModeldestinationFileUrl = documentsUrl.appendingPathComponent("Panono.jpg")
        
        let fileURL = URL(string: ((lab! as! [String : Any])["material"] as? String)!)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:fileURL!)
        print("Descargado material...")
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("El material se descargo con éxito. Código de confirmación: \(statusCode)")
                    self.letContinueModel = true
                    self.modeloSpin.stopAnimating()
                    self.modeloSpin.isHidden = true
                    self.modeloButton.isEnabled = true
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: self.ModeldestinationFileUrl!)
                } catch (let writeError) {
                    print("Error creando el archivo \(String(describing: self.ModeldestinationFileUrl)) : \(writeError)")
                }
                
            } else {
                print("Error en la descarga: Descripción de error: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
    
    func downloadVideo(){
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        destinationFileUrl = documentsUrl.appendingPathComponent("Tec21.mp4")
        
        let fileURL = URL(string: ((lab! as! [String : Any])["video"] as? String)!)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:fileURL!)
        print("Descargando video...")
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("El video se descargo con éxito. Código de confirmación: \(statusCode)")
                    self.letContinue = true
                    self.videoSpin.stopAnimating()
                    self.videoSpin.isHidden = true
                    self.videoButton.isEnabled = true
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: self.destinationFileUrl!)
                } catch (let writeError) {
                    print("Error creando el video \(String(describing: self.destinationFileUrl)) : \(writeError)")
                }
                
            } else {
                print("Error en la descarga. Descripción de error: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Descargando Imagen...")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Imagen descargada...")
            DispatchQueue.main.async() {
                self.foto.image = UIImage(data: data)
                self.fotosSpin.stopAnimating()
                self.fotosSpin.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ARVideoViewController {
            if(letContinue){
                let vc = segue.destination as! ARVideoViewController
                vc.videoURL = destinationFileUrl
                vc.navigationItem.title = "video"
            }else{
                // create the alert
                let alert = UIAlertController(title: "Espere", message: "El video aún sigue en descarga.", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if segue.destination is ModeloViewController {
            if(letContinueModel){
                let vc = segue.destination as! ModeloViewController
                vc.modelURL = ModeldestinationFileUrl
                vc.navigationItem.title = "material"
            }else{
                let alert = UIAlertController(title: "Espere", message: "El material aún sigue en descarga.", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
        if segue.destination is CalendarViewController {
            if(letContinueModel){
                let vc = segue.destination as! CalendarViewController
                location.text = (lab! as! [String : Any])["ubicacion"] as? String
                vc.classURL = location.text
                vc.navigationItem.title = "material"
            }else{
                let alert = UIAlertController(title: "Espere", message: "El material aún sigue en descarga.", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isMovingToParent {
            do {
                try FileManager.default.removeItem(at: destinationFileUrl!)
                print("El archivo se quito con éxito de:  \(String(describing: destinationFileUrl))")
            }
            catch let error as NSError {
                print("Error: \(error)")
            }
            
            do {
                try FileManager.default.removeItem(at: ModeldestinationFileUrl!)
                print("El archivo se quito con éxito de: \(String(describing: ModeldestinationFileUrl))")
            }
            catch let error as NSError {
                print("Error: \(error)")
            }
        }
    }
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
