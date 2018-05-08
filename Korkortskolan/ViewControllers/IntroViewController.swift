//
//  IntroViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/22.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController ,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageCtrl: UIPageControl!
    
    @IBOutlet weak var viewScreen1: UIView!
    @IBOutlet weak var viewScreen2: UIView!
    
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPaginationViews()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickContinue(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "introduced")
        let tabView = self.storyboard?.instantiateViewController(withIdentifier: "SB_TABVIEW")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabView
    }
    func setupPaginationViews(){        
        
        frame.origin.x = scrollView.frame.size.width * CGFloat(0)
        frame.size = scrollView.frame.size
        viewScreen1.frame = frame
        self.scrollView .addSubview(viewScreen1)
        
        frame.origin.x = scrollView.frame.size.width * CGFloat(1)
        frame.size = scrollView.frame.size
        viewScreen2.frame = frame
        self.scrollView .addSubview(viewScreen2)
        
        scrollView.contentSize = CGSize(width:scrollView.frame.size.width * 2,height: self.scrollView.frame.size.height)
    }
    
    @IBAction func pageCtrlChanged(_ sender: UIPageControl) {
        let x = CGFloat(pageCtrl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageCtrl.currentPage = Int(pageNumber)
    }
}
