//
//  RoutesVC.swift
//  BusRoute
//
//  Created by Tomislav Luketic on 4/23/18.
//  Copyright © 2018 lux. All rights reserved.
//

import UIKit

class RoutesVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: RoutesVM = {
        return RoutesVM()
    }()
    
    var scrollToRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initVM()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (scrollToRow != -1){
            let indexPath = IndexPath(row: scrollToRow, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
            scrollToRow = -1
        }
        
    }

    fileprivate func setupViews(){
       tableView.tableFooterView = UIView()
    }
    
    fileprivate func initVM(){
        
        viewModel.reloadTableViewClosure = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
        }
        
        viewModel.showAlertClosure = { [weak self] message in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
              strongSelf.showAlert(message)
            }
        }
        
        viewModel.fetchRoutes(urlString: "http://www.mocky.io/v2/5a0b474a3200004e08e963e5")
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
  

}

extension RoutesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoutesCell") as? RoutesCell else {
            fatalError("'RoutesCell' does not exist in storyboard")
        }
        
        let route = viewModel.routes[indexPath.row]
        cell.lblRoute.text = route.name
        
        if let imgUrl = route.imageUrl
        {
            cell.imgView.rw_setImage(url: URL(string: imgUrl) , defaultImgName: "bus")
        }
        else
        {
            cell.imgView.image = UIImage(named: "bus")
        }
              
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.routes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

extension RoutesVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SwipeableVC
        {
            if let cell = sender as? RoutesCell
            {
               let indexPath = tableView.indexPath(for: cell)
               vc.numPages = viewModel.routes.count
               vc.currentRow = indexPath!.row
               vc.routesVM = viewModel
               vc.delegate = self
               
            }
        }
    }
}

extension RoutesVC : SwipeableDelegate {
    func pageChanged(page: Int) {
        scrollToRow = page
    }
    
    
}

