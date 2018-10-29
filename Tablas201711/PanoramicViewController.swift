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


    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "http://martinmolina.com.mx/201813/images/CEDETEC/101Panono%20-%20Cabina%20de%20control.jpg")
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        panoramaView.image = image
       
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

}
