//
//  FirstViewController.swift
//  Tablas201711
//
//  Created by molina on 20/02/17.
//  Copyright © 2017 Tec de Monterrey. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func compartir(_ sender: Any) {
        print("Hola")
        
        let texto="Esta es la App de iCEDETEC donde pordrás encontrar todos sus salones e interactuar con ellos"
        let liga="URL de AppStore iCEDETEC"
       
        if let imagen2:UIImage=UIImage(named:"shareImage")!
        {
            let objetos:[AnyObject]=[texto as AnyObject,liga as AnyObject,imagen2]
            
            let actividad=UIActivityViewController(activityItems: objetos,applicationActivities: nil)
            
            actividad.excludedActivityTypes=[UIActivity.ActivityType.mail]
            self.present(actividad,animated:true, completion:nil)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

