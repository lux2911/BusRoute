//
//  RouteDetailVC.swift
//  BusRoute
//
//  Created by Tomislav Luketic on 4/23/18.
//  Copyright © 2018 lux. All rights reserved.
//

import UIKit

class RouteDetailVC: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    
    var routesVM : RoutesVM?
    var currentRow : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    fileprivate func setupViews(){
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.bounces = false
    }

  
}

extension RouteDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if indexPath.row == 0 && indexPath.section == 0
       {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RouteDetailsHeaderCell") as? RouteDetailsHeaderCell else {
                fatalError("Cell of type 'RouteDetailsHeaderCell' does not exist in storyboard")
            }
        
            cell.lblRouteName.text = routesVM?.routes[currentRow].name
            cell.lblRouteDescription.text = routesVM?.routes[currentRow].description
            cell.imgAccessibility.image = routesVM!.routes[currentRow].accessible ? UIImage(named: "accessibility") : nil
            cell.imgBus.image = UIImage(named: "bus")
        
            if let imgUrl = routesVM?.routes[currentRow].imageUrl{
                cell.imgBus.rw_setImage(url: URL(string: imgUrl) , defaultImgName: "bus")
            }
        
            return cell
       }
       else
       {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RouteDetailsCell") as? RouteDetailsCell else {
                fatalError("Cell of type 'RouteDetailsCell' does not exist in storyboard")
            }
        
            cell.lblStopName.text = routesVM?.routes[currentRow].stops[indexPath.row]["name"]
            cell.imgViewLine.isHidden = indexPath.row == tableView.numberOfRows(inSection: 1) - 1
            cell.imgTop.isHidden = indexPath.row == 0
            return cell
       }
        
        
    }
    
   func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : routesVM!.routes[currentRow].stops.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UITableViewAutomaticDimension
        }
        return 90
    }
    
   
}
