//
//  RouteDetailsHeaderCell.swift
//  BusRoute
//
//  Created by Tomislav Luketic on 4/24/18.
//  Copyright © 2018 lux. All rights reserved.
//

import UIKit

class RouteDetailsHeaderCell: UITableViewCell {

    
    @IBOutlet weak var imgBus: UIImageView!
    
    @IBOutlet weak var lblRouteName: UILabel!
    
    @IBOutlet weak var lblRouteDescription: UILabel!
    @IBOutlet weak var imgAccessibility: UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.selectionStyle = .none
    }

   

}
