//
//  UnlimitedQuizViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/15.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse
class UnlimitedQuizViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var mcollectionView: UICollectionView!
    @IBOutlet weak var view_notification: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(arrUnlimitedQuiz.count <= 0){
            getDBCategoryDetails()
        }
        view_notification.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickStatistic(_ sender: Any) {
        let moreView = self.storyboard?.instantiateViewController(withIdentifier: "SB_STATISTICS")
        self.navigationController?.pushViewController(moreView!, animated: false)
        
    }
    
    @IBAction func clickHome(_ sender: Any) {
        let moreView = self.storyboard?.instantiateViewController(withIdentifier: "SB_CATEGORY")
        self.navigationController?.pushViewController(moreView!, animated: false)

    }
    
    @IBAction func clickUnlimited(_ sender: Any) {
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
    @IBAction func clickClose(_ sender: Any) {
        view_notification.isHidden = true
    }
    
    func getDBCategoryDetails(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = PFQuery(className: "Unlimited_Quiz")
        query.order(byAscending: "order")
        query.findObjectsInBackground(block: { (unlimited_arrs : [PFObject]?, error: Error!) -> Void in
            if error == nil {
                arrUnlimitedQuiz = unlimited_arrs!
                if(arrUnlimitedQuiz.count == 0){
                    Helper.showAlert(target: self, title:"Warning!" , message: "Please wait. Unlimited Quiz was not uploaded.")
                }
                DispatchQueue.main.async {
                    self.mcollectionView.reloadData()
                }
            }else{
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUnlimitedQuiz.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 2
        let spaceBetweenCells: CGFloat = 40
        let screenWidth = (collectionView.frame.size.width - (cellsAcross-1)*spaceBetweenCells) / cellsAcross
        if(indexPath.item == 0){
            return CGSize(width: collectionView.frame.size.width, height: 80)
        }
        else if(indexPath.item == arrUnlimitedQuiz.count){
            // Category Quiz
            return CGSize(width: collectionView.frame.size.width, height: screenWidth - 30)
        }else{
            return CGSize(width: screenWidth, height: screenWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.item == 0){
            let mItem = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_reading", for: indexPath)
            return mItem
        }
        else if(indexPath.item != arrUnlimitedQuiz.count){
            let mItem = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_unlimitedquiz", for: indexPath) as! UnlimitedQuizCollectionViewCell
            let index = indexPath.item
            mItem.info = arrUnlimitedQuiz[index-1]
            mItem.showCell()
            return mItem
        }else{
            let mItem = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_final", for: indexPath) as! CategoryFinalCollectionViewCell
            return mItem
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFullVersion{
            if(indexPath.item == 0){
                let unlimitedMatView = self.storyboard?.instantiateViewController(withIdentifier: "SB_UNLIMITEDMAT")
                self.navigationController?.pushViewController(unlimitedMatView!, animated: true)
            }else{
                let quizView = self.storyboard?.instantiateViewController(withIdentifier: "SB_UNLIMITEDQUIZROOM") as! UnlimitedQuizRoomViewController
                let rowCategory = arrUnlimitedQuiz[indexPath.row-1]
                quizView.unlimited_id = rowCategory["unlimited_quiz_id"] as! String
                quizView.unlimited_title = rowCategory["quiz_title"] as! String
                quizView.unlimited_type = rowCategory["type"] as! String
                self.navigationController?.pushViewController(quizView, animated: true)
            }
            
        }else{
            view_notification.isHidden = false
        }
    }
}
