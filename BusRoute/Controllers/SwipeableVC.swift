//
//  SwipeableVC.swift
//  BusRoute
//
//  Created by Tomislav Luketic on 4/24/18.
//  Copyright © 2018 lux. All rights reserved.
//

import UIKit

protocol SwipeableDelegate : class {
    func pageChanged(page: Int)
}

class SwipeableVC: UIViewController, UIScrollViewDelegate {
	
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentRow : Int = 0 {
        didSet {
             curPage = currentRow
        }
    }
    
    weak var delegate : SwipeableDelegate?
    
    var curPage = 0
    var numPages = 0
    var routesVM : RoutesVM?
    var mod = 0
    
	var pages = [UIView?]()
	var transitioning = false
		
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
        
        _ = setupInitialPages
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
		pageControl.numberOfPages = numPages / 2
        mod = Int(floor(Double(numPages / pageControl.numberOfPages)))
		pageControl.currentPage = curPage / mod
        
    }

   
	lazy var setupInitialPages: Void = {
		
		adjustScrollView()
        loadStartPages(page: curPage)
        gotoPage(page: curPage, animated: false)
		
	}()

	
    fileprivate func removeAnyViews(page: Int){
        
        guard page - 2 >= 0 , page + 2 < pages.count else {return}
        
        for idx in stride(from: page-2, through: 0, by: -1){
            let aView = pages[idx]
            if aView == nil {break}
            for vc in self.childViewControllers{
                if vc.view == aView{
                    removeVC(vc: vc)
                    pages[idx] = nil
                    break
                }
            }
        }
        
        for idx in page+2..<pages.count{
            let aView = pages[idx]
            if aView == nil {break}
            for vc in self.childViewControllers{
                if vc.view == aView{
                    removeVC(vc: vc)
                    pages[idx] = nil
                    break
                }
            }
        }
    }
    
    fileprivate func removeVC(vc: UIViewController){
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
	
	fileprivate func adjustScrollView() {
		
        var safeAreaY : CGFloat
        
        if #available(iOS 11, *){
            safeAreaY = self.view.safeAreaInsets.top
        }
        else{
            safeAreaY = self.topLayoutGuide.length
        }
        
        scrollView.contentSize =
			CGSize(width: scrollView.frame.width * CGFloat(numPages),
			       height: scrollView.frame.height - safeAreaY)
	}
	
		
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		
		removeAnyViews(page: self.curPage)
		
		coordinator.animate(alongsideTransition: nil) { _ in
			
			self.adjustScrollView()
			self.transitioning = true
            self.loadStartPages(page: self.curPage)
            self.gotoPage(page: self.curPage, animated: false)
			self.transitioning = false
		}
		
		super.viewWillTransition(to: size, with: coordinator)
	}
	
	
	fileprivate func loadPage(_ page: Int) {
		guard page < numPages && page != -1 else { return }
		
		if pages[page] == nil {
			
				var frame = scrollView.frame
				frame.origin.x = frame.width * CGFloat(page)
            
                var safeAreaY : CGFloat
            
                if #available(iOS 11, *){
                    safeAreaY = self.view.safeAreaInsets.top
                }
                else{
                    safeAreaY = self.topLayoutGuide.length
                }
            
                frame.origin.y = -safeAreaY
				frame.size.height += safeAreaY
				
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "RouteDetailVC") as! RouteDetailVC
                vc.currentRow = page
                vc.routesVM = routesVM
            
                self.addChildViewController(vc)
                vc.view.frame = frame
                scrollView.addSubview(vc.view)
                vc.didMove(toParentViewController: self)
                pages[page] = vc.view
            
		}
	}
	
    
    fileprivate func loadStartPages(page: Int) {
        
        guard (page >= 0 && page < numPages) || transitioning else { return }
     
        pages = [UIView?](repeating: nil, count: numPages)
        
        loadPage(Int(page) - 1)
        loadPage(Int(page))
        loadPage(Int(page) + 1)
    }
    
    fileprivate func loadNextPage(page: Int, direction: Int) {
        
        guard (page >= 0 && page  < numPages) || transitioning else { return }
        
        removeAnyViews(page: page)
        loadPage(page + (1 * direction))
        
    }
	
	fileprivate func gotoPage(page: Int, animated: Bool) {
		
        var bounds = scrollView.bounds
		bounds.origin.x = bounds.width * CGFloat(page)
		bounds.origin.y = 0
		scrollView.scrollRectToVisible(bounds, animated: animated)
	}
	
		
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		
		let pageWidth = scrollView.frame.width
		let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        let direction = -(curPage - Int(page))
        
        if Int(page) % mod == 0{
            pageControl.currentPage = Int(page) / mod
        }
        
        loadNextPage(page: Int(page), direction: direction)
        curPage = Int(page)
        delegate?.pageChanged(page: curPage)
       
	}
	
	
    

}

