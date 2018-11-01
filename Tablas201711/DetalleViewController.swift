//
//  DetalleViewController.swift
//  Tablas201711
//
//  Created by molina on 23/02/17.
//  Copyright © 2017 Tec de Monterrey. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController {

    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var nombre:String=""
    var horario:String=""
    var idsalon:String=""
    //var url:String=""
    
    @IBOutlet weak var laNombre: UILabel!
    @IBOutlet weak var laHorario: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        
        view.addSubview(activityIndicator)
        
        // Do any additional setup after loading the view.
        laNombre.text = nombre
        laHorario.text = horario
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func Imagenes(_ sender: Any) {
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "Imagenes") as! ImagenesTableViewController
            
            siguienteVista.idsalon = self.idsalon
            
            self.navigationController?.pushViewController(siguienteVista, animated: true)
            
            self.activityIndicator.stopAnimating()
        }
        
    }
 

    @IBAction func Videos(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        
            let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "Videos") as! VideosTableViewController
            
            
            siguienteVista.idsalon = self.idsalon
            
            self.navigationController?.pushViewController(siguienteVista, animated: true)
            
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    @IBAction func AR(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        
            let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "Modelos") as! ModelosTableViewController
            
            
            siguienteVista.idsalon = self.idsalon
            
            self.navigationController?.pushViewController(siguienteVista, animated: true)
            
            self.activityIndicator.stopAnimating()
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
