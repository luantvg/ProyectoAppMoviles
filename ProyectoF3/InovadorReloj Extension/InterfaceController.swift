//
//  InterfaceController.swift
//  InovadorReloj Extension
//
//  Created by Aldo Lopez Vallin on 11/9/18.
//  Copyright © 2018 Fafnir. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    
    @IBOutlet weak var holaTexto: WKInterfaceLabel!
    @IBAction func botonHola() {
        holaTexto.setText("Hola mundo inovador!")
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
