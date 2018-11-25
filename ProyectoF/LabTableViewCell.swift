//
//  LabTableViewCell.swift
//  ProyectoF
//
//  Created by cdt307 on 10/23/18.
//  Copyright © 2018 Fafnir. All rights reserved.
//

import UIKit

class LabTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UITextView!
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
