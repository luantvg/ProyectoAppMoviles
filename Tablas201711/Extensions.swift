//
//  Extensions.swift
//  Portal3
//
//  Created by Davidson Family on 2/14/18.
//  Copyright © 2018 Davidson Family. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

var width : CGFloat = 0.03
var height : CGFloat = 1
var length : CGFloat = 1

var doorLength : CGFloat = 0.3

//var whichSide : String = ""

func createBox(isDoor : Bool, whichSide: String) -> SCNNode {
    let node = SCNNode()
    
    //Add First Box
    let firstBox = SCNBox(width: width, height: height, length: isDoor ? doorLength : length, chamferRadius: 0)
    if(whichSide == "top"){
        firstBox.firstMaterial?.diffuse.contents = UIImage(named: "top2")
    }
    if(whichSide == "bottom"){
        firstBox.firstMaterial?.diffuse.contents = UIImage(named: "bottom2")
    }
    if(whichSide == "left"){
        firstBox.firstMaterial?.diffuse.contents = UIImage(named: "left2")
    }
    if(whichSide == "right"){
        firstBox.firstMaterial?.diffuse.contents = UIImage(named: "right2")
    }
    if(whichSide == "front"){
        firstBox.firstMaterial?.diffuse.contents = UIImage(named: "front2")
    }
    if(whichSide == "back"){
        firstBox.firstMaterial?.diffuse.contents = UIImage(named: "back2")
    }
    let firstBoxNode = SCNNode(geometry: firstBox)
    firstBoxNode.renderingOrder = 200
    
    node.addChildNode(firstBoxNode)
    
    //Add Masked Box
    let maskedBox = SCNBox(width: width, height: height, length: isDoor ? doorLength : length, chamferRadius: 0)
    maskedBox.firstMaterial?.diffuse.contents = UIColor.white
    maskedBox.firstMaterial?.transparency = 0.000000001
    
    let maskedBoxNode = SCNNode(geometry: maskedBox)
    maskedBoxNode.renderingOrder = 100
    maskedBoxNode.position = SCNVector3.init(width, 0, 0)
    
    node.addChildNode(maskedBoxNode)
    
    return node
}

extension FloatingPoint {
    var degreesToRadians : Self {
        return self * .pi / 180
    }
    var radiansToDegrees : Self {
        return self * 180 / .pi
    }
}







