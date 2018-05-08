//
//  CategoryViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/11.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
class CategoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var clv_steps: UICollectionView!
    @IBOutlet weak var view_notification: UIView!
    @IBOutlet weak var view_welcome: UIView!
    @IBOutlet weak var view_paidnotification: UIView!
    
    var ableCategories = 0
    var doneCategories = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        getDBCategory()
        view_notification.isHidden = true
        view_paidnotification.isHidden = true
        view_welcome.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)

        calcDoneCategories()
        clv_steps.reloadData()
    }
    
    func calcDoneCategories(){
        if(arrCategories.count > 0){
            doneCategories = 0
            for category in arrCategories{
                if(UserDefaults.standard.bool(forKey: "done_quiz_categoryid_" + (category["category_id"] as! String))){
                    doneCategories += 1
                }
            }
        }
        if(!isFullVersion){
            ableCategories = 1 + accessAppRated
        }else{
            ableCategories = 1 + accessAppRated + doneCategories
        }
    }
    func getDBCategory(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = PFQuery(className: "Category")
        query.order(byAscending: "category_id")
        query.findObjectsInBackground(block: { (categories : [PFObject]?, error: Error!) -> Void in
            if error == nil {
                arrCategories = categories!
                if(arrCategories.count == 0){
                    Helper.showAlert(target: self, title:"Warning!" , message: "Please wait. Content does not uploaded.")
                }
                self.calcDoneCategories()
                self.clv_steps.reloadData()
                if(isFullVersion){
                    self.view_welcome.isHidden = true
                }else if(isOpened){
                    self.view_welcome.isHidden = true
                }else{
                    self.view_welcome.isHidden = false
                    isOpened = true
                }
            }else{
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    
    //View Notification Click Events
    
    @IBAction func clickStatistic(_ sender: Any) {
        let moreView = self.storyboard?.instantiateViewController(withIdentifier: "SB_STATISTICS")
        self.navigationController?.pushViewController(moreView!, animated: false)

    }
    
    @IBAction func clickHome(_ sender: Any) {
    }
    
    @IBAction func clickUnlimited(_ sender: Any) {
        let moreView = self.storyboard?.instantiateViewController(withIdentifier: "SB_UNLIMITEDQUIZ")
        self.navigationController?.pushViewController(moreView!, animated: false)
    }
    @IBAction func click_close(_ sender: Any) {
        view_notification.isHidden = true
    }
    
    @IBAction func clickClosePaid(_ sender: Any) {
        view_paidnotification.isHidden = true
    }
    
    @IBAction func clickMore(_ sender: Any) {
        let moreView = self.storyboard?.instantiateViewController(withIdentifier: "SB_MORE")
        moreView?.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(moreView!, animated: true)
    }
    @IBAction func click_BuyFullAccess(_ sender: Any) {
        let url = URL(string: "https://itunes.apple.com/us/app/vans-park-series/id1207703201?mt=8")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBAction func click_RateApp(_ sender: Any) {
        let appID = "959379869"
        let url = URL(string : "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)")
        UIApplication.shared.open(url!, options: [:], completionHandler: {action in
            let userDefults = UserDefaults.standard
            userDefults.setValue("rated", forKey: "rated")
            accessAppRated = 1
            self.view_notification.isHidden = true
        })
    }
    
    @IBAction func closeWelcome(_ sender: Any) {
        view_welcome.isHidden = true
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 2
        let spaceBetweenCells: CGFloat = 30
        let screenWidth = (collectionView.frame.size.width - (cellsAcross-1)*spaceBetweenCells) / cellsAcross
        if(indexPath.item == arrCategories.count-1){
            // Category Quiz
            return CGSize(width: collectionView.frame.size.width, height: screenWidth - 30)
        }else{
            return CGSize(width: screenWidth, height: screenWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.item < arrCategories.count-1){
            let mItem = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_category", for: indexPath) as! CategoryCollectionViewCell
            let rowCategory = arrCategories[indexPath.row]
            mItem.lbl_stepname.text = rowCategory["category_name"] as? String
            
            let total = totalLevelCountsPerCategory
            let done = UserDefaults.standard.integer(forKey: "done_levels_categoryid_"+(rowCategory["category_id"] as! String))
           
            if(total > 0){
                mItem.showProgress(countDone: done, total: total)
            }else{
                mItem.showProgress(countDone: 0, total: 1)
            }
            
            if(ableCategories <= indexPath.item){
                mItem.img_category.image = UIImage.init(named: "category_gray")
            }else{
                mItem.img_category.image = UIImage.init(named: "category_yellow")
            }

            return mItem
        }else{
            let mItem = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_final", for: indexPath) as! CategoryFinalCollectionViewCell
            return mItem
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(ableCategories <= indexPath.item){
            // Unaccessable
            if isFullVersion {
                Helper.showFadeIn(view_paidnotification, delay: 0.0, duration: 0.5)
            }else {
                Helper.showFadeIn(view_notification, delay: 0.0, duration: 0.5)
            }
        }else{
            // Accessable
            let detailView = self.storyboard?.instantiateViewController(withIdentifier: "SB_CATEGORYDETAIL") as! CategoryDetailViewController
            let rowCategory = arrCategories[indexPath.row]
            detailView.Category_Id = rowCategory["category_id"] as! String
            detailView.Category_title = rowCategory["category_name"] as! String
            self.navigationController?.pushViewController(detailView, animated: true)
        }
    }
    
}
