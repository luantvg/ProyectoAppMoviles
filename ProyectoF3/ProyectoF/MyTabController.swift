//
//  MyTabController.swift
//  ProyectoF
//
//  Created by cdt307 on 10/23/18.
//  Copyright © 2018 Fafnir. All rights reserved.
//

import UIKit
import Foundation

class MyTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedViewController = self.viewControllers?[1]
    }

}
