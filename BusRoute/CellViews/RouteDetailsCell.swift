//
//  RouteDetailsCell.swift
//  BusRoute
//
//  Created by Tomislav Luketic on 4/23/18.
//  Copyright © 2018 lux. All rights reserved.
//

import UIKit

class RouteDetailsCell: UITableViewCell {

    
    @IBOutlet weak var imgViewDot: UIImageView!
    
    @IBOutlet weak var lblStopName: UILabel!
    @IBOutlet weak var imgViewLine: UIImageView!
    @IBOutlet weak var imgTop: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.contentView.sendSubview(toBack: imgViewLine)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imgViewLine.isHidden = false
        
    }

   

}
