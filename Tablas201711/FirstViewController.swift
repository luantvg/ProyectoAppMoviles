//
//  FirstViewController.swift
//  Tablas201711
//
//  Created by molina on 20/02/17.
//  Copyright © 2017 Tec de Monterrey. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController {

    var hide = true;
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoButton.isHidden=true
        shareButton.isHidden=true
        locationButton.isHidden=true
    }

    @IBAction func ShowMore(_ sender: Any) {
    
        if hide {
            infoButton.isHidden=false
            shareButton.isHidden=false
            locationButton.isHidden=false
            
            hide=false
            
        }else{
            infoButton.isHidden=true
            shareButton.isHidden=true
            locationButton.isHidden=true
            
            hide=true
        }
        
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
    
    
   
        
        /*
        
        let lat:CLLocationDegrees = 19.283523
        let long:CLLocationDegrees = -99.135497
        
        let regionDistance:CLLocationDistance = 1
        let coordinates = CLLocationCoordinate2D(latitude: lat,longitude: long)
        
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey : NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey : NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placeMark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placeMark)
        
        mapItem.name = "CEDETEC , ITESM CCM"
        mapItem.url = URL(string: "https://tec.mx/es/somostecccm")
        mapItem.phoneNumber = "5554832025"
        
        mapItem.openInMaps(launchOptions: options)
 
        */

}

