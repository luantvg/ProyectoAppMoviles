//
//  MapViewController.swift
//  Tablas201711
//
//  Created by Diogo Burnay on 11/21/18.
//  Copyright © 2018 Tec de Monterrey. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var Map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Map.showsUserLocation = true
        Map.delegate = self
        // Do any additional setup after loading the view.
        
        let location = CLLocationCoordinate2D( latitude: 19.283523, longitude: -99.135497)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        Map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "CEDETEC"
        annotation.subtitle = "ITESM CCM"
        
        Map.addAnnotation(annotation)
    }
    
    @IBAction func cerrarVista(_ sender: Any) {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func abrirMaps(_ sender: Any) {
    
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
