//
//  AgendarViewController.swift
//  Tablas201711
//
//  Created by Diogo Burnay on 11/25/18.
//  Copyright © 2018 Tec de Monterrey. All rights reserved.
//

import UIKit
import EventKit

class AgendarViewController: UIViewController {

    var salon:String=""
    
    var fechaInicioDate:Date? = nil
    var fechaFinalDate:Date? = nil
    
    @IBOutlet weak var salonLabel: UILabel!
    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var ViewDatePickerInicio: UIView!
    @IBOutlet weak var DatePickerInicio: UIDatePicker!
    
    @IBOutlet weak var ViewDatePickerFinal: UIView!
    @IBOutlet weak var DatePickerFinal: UIDatePicker!
    
    @IBOutlet weak var fechaInicio: UIButton!
    
    @IBOutlet weak var fechaSalida: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        salonLabel.text = salon
        
        ViewDatePickerInicio.isHidden = true
        ViewDatePickerFinal.isHidden = true
    }
    
    
    @IBAction func AceptarInicio(_ sender: Any) {
        fechaInicioDate = DatePickerInicio.date
        fechaInicio.setTitle("\(DatePickerInicio.date)", for: .normal)
        ViewDatePickerInicio.isHidden = true
    }
    
    
    @IBAction func AceptarFinal(_ sender: Any) {
        fechaFinalDate = DatePickerFinal.date
        fechaSalida.setTitle("\(DatePickerFinal.date)", for: .normal)
        ViewDatePickerFinal.isHidden = true
    }
    
    
    @IBAction func AgregarCalendario(_ sender: Any) {
        print(self.salon)
        print(self.fechaInicioDate)
        print(self.fechaFinalDate)
        print(self.tituloTextField.text)
        
        let eventStore:EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil){
                print("granted \(granted)")
                print("error \(error)")
                
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.tituloTextField.text
                event.startDate = self.fechaInicioDate
                event.endDate = self.fechaFinalDate
                event.notes = "El salón apartado es : \(self.salon) y fue apartado por mi"
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                do{
                    try eventStore.save(event, span: .thisEvent)
                }catch let error as NSError {
                    print("error \(error)")
                }
                //self.Alerta(Title: "hola", Message: "Adios")
                print ("Save Event")
            }else{
                print("error \(error)")
            }
        }
    }
    
    
    @IBAction func botonFehcaInicio(_ sender: Any) {
        ViewDatePickerInicio.isHidden = false
    }
    
    @IBAction func botonFechaSalida(_ sender: Any) {
        ViewDatePickerFinal.isHidden = false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
    func Alerta (Title: String, Message: String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
 */
}
