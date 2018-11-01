//
//  DetalleViewController.swift
//  Tablas201711
//
//  Created by molina on 23/02/17.
//  Copyright © 2017 Tec de Monterrey. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController {

    var nombre:String=""
    var horario:String=""
    var idsalon:String=""
    //var url:String=""
    
    @IBOutlet weak var laNombre: UILabel!
    @IBOutlet weak var laHorario: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        laNombre.text = nombre
        laHorario.text = horario
    }
    

    /*
    @IBAction func toPanoView(_ sender: Any) {
        let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "panoramicVisor") as! PanoramicViewController
        
        siguienteVista.uurl = url
        
        self.navigationController?.pushViewController(siguienteVista, animated: true)
        
    }
 */
 
 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func Imagenes(_ sender: Any) {
        let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "Imagenes") as! ImagenesTableViewController
        
        
        siguienteVista.idsalon = idsalon
        
        self.navigationController?.pushViewController(siguienteVista, animated: true)
    }
 

    @IBAction func Videos(_ sender: Any) {
    }
    
    @IBAction func AR(_ sender: Any) {
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
