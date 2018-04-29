//
//  RoutesCell.swift
//  BusRoute
//
//  Created by Tomislav Luketic on 4/23/18.
//  Copyright © 2018 lux. All rights reserved.
//

import UIKit

class RoutesCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblRoute: UILabel!
    
   
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgView.image = UIImage(named: "bus")
    }

   

}
