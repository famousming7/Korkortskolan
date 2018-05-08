//
//  StatisticsViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/12/07.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import GTProgressBar
import MBProgressHUD
import Parse
class StatisticsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource {

    var progressBar:GTProgressBar!
    @IBOutlet weak var view_over_line: UIView!
    @IBOutlet weak var view_history_line: UIView!
    @IBOutlet weak var clv_quizes: UICollectionView!
    @IBOutlet weak var view_overview: UIView!
    @IBOutlet weak var view_history: UIView!
    
    @IBOutlet weak var tbl_history: UITableView!
    var arrHistory:NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        arrHistory = NSMutableArray.init()
        // Do any additional setup after loading the view.
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showOverView()
        if(arrUnlimitedQuiz.count == 0){
            getDBUnlimitedDetails()
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizerDirection.right:
                //write your logic for right swipe
                print("Swiped right")                
                History()
                break
            case UISwipeGestureRecognizerDirection.left:
                //write your logic for left swipe
                print("Swiped left")
                OverView()
                break
            default:
                break
            }
        }
    }
    func OverView(){
        view_over_line.backgroundColor = UIColor.init(rgb: 0xdcdcdc)
        view_history_line.backgroundColor = UIColor.init(rgb: 0xffffff)
        view_overview.isHidden = false
        view_history.isHidden = true
        showOverView()
    }
    func History(){
        view_over_line.backgroundColor = UIColor.init(rgb: 0xffffff)
        view_history_line.backgroundColor = UIColor.init(rgb: 0xdcdcdc)
        view_overview.isHidden = true
        view_history.isHidden = false
        showHistory()
    }
    @IBAction func clickOverview(_ sender: Any) {
        OverView()
    }
    @IBAction func clickHistory(_ sender: Any) {
       History()
    }
    
    @IBAction func clickStatistic(_ sender: Any) {
        
    }
    
    @IBAction func clickHome(_ sender: Any) {
        let moreView = self.storyboard?.instantiateViewController(withIdentifier: "SB_CATEGORY")
        self.navigationController?.pushViewController(moreView!, animated: false)        
    }
    
    @IBAction func clickUnlimited(_ sender: Any) {
        let moreView = self.storyboard?.instantiateViewController(withIdentifier: "SB_UNLIMITEDQUIZ")
        self.navigationController?.pushViewController(moreView!, animated: false)
    }
    @IBAction func clickMore(_ sender: Any) {
        let moreView = self.storyboard?.instantiateViewController(withIdentifier: "SB_MORE")
        moreView?.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(moreView!, animated: true)
    }
    
    func getDBUnlimitedDetails(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = PFQuery(className: "Unlimited_Quiz")
        query.order(byAscending: "createdAt")
        query.findObjectsInBackground(block: { (unlimited_arrs : [PFObject]?, error: Error!) -> Void in
            if error == nil {
                arrUnlimitedQuiz = unlimited_arrs!
                if(arrUnlimitedQuiz.count == 0){
                    Helper.showAlert(target: self, title:"Warning!" , message: "Please wait. Unlimited Quiz was not uploaded.")
                }else{
                    self.clv_quizes.reloadData()
                }
            }else{
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func showOverView(){
        
    }
    

    
    func showHistory(){
        let history_count = UserDefaults.standard.integer(forKey: "history_count")
        var from = 1
        let to = history_count
        if(history_count>15){
            from = history_count - 15
        }
        if(history_count>0){
            for index in (from...to).reversed(){
                let history = UserDefaults.standard.dictionary(forKey: "history_"+String(index))
                arrHistory.add(history!)
            }
            tbl_history.reloadData()
        }
    }
    
    
    /// History Table Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHistory.count > 15 ? 15 : arrHistory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_history", for: indexPath) as! StatisticHistoryTableViewCell
        let history = arrHistory[indexPath.row] as! [String:String]
        cell.lbl_quiz.text = history["title"]
        cell.lbl_time.text = history["duration"]
        cell.lbl_score.text = history["correct_count"]! + "/" + history["total_count"]!
        cell.lbl_date.text = history["time"]
        return cell
    }
    /// Overview
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUnlimitedQuiz.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(indexPath.item == 0){
            return CGSize(width: collectionView.frame.size.width, height: 130)
        }else{
            let cellsAcross: CGFloat = 2
            let spaceBetweenCells: CGFloat = 40
            let screenWidth = (collectionView.frame.size.width - (cellsAcross-1)*spaceBetweenCells) / cellsAcross
            return CGSize(width: screenWidth, height: screenWidth)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let mItem = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_title", for: indexPath) as! StatisticTitleCollectionViewCell
            
            let totalLevels = 15 * arrCategories.count
            var doneLevels = 0
            for category in arrCategories{
                let category_id = category["category_id"] as! String
                let doneLevel = UserDefaults.standard.integer(forKey:  "done_levels_categoryid_"+category_id)
                doneLevels += doneLevel
            }
            mItem.lbl_count.text = String(doneLevels) + " / " + String(totalLevels)
            mItem.count = doneLevels
            mItem.total = totalLevels
            mItem.showProgress(countDone: doneLevels, total: totalLevels)
            return mItem
        }else{
            let mItem = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_percent", for: indexPath) as! StatisticsCollectionViewCell
            let info = arrUnlimitedQuiz[indexPath.item - 1]
            let unlimitedID = info["unlimited_quiz_id"] as! String
            if let data = UserDefaults.standard.object(forKey: "unlimited_quiz_res_" + unlimitedID) as? NSData {
                mItem.m_arrQuiz = (NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [Quiz])!
            }else{
                mItem.m_arrQuiz = []
            }
            mItem.showProgressBar()

            mItem.lbl_title.text = info["quiz_title"] as? String
            
            return mItem
        }
    }
}
