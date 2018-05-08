//
//  CategoryDetailViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/13.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse
class CategoryDetailViewController: UIViewController {

    var Category_Id:String!
    var Category_title:String!
    var m_arrDetail:NSMutableArray!
    var doneLevels = 0
    var starViews : NSMutableArray!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btn_levels: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_arrDetail = NSMutableArray.init()
        starViews = NSMutableArray.init()
        lbl_title.text = Category_title
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        showMap()
    }
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickLevels(_ sender: UIButton) {
        let level = sender.tag
        if(level > doneLevels + 1) { return }
        if(level == totalLevelCountsPerCategory){
            // FINAL
            let catquizView = self.storyboard?.instantiateViewController(withIdentifier: "SB_CATEGORYQUIZ") as! CategoryQuizViewController
            catquizView.category_id = Category_Id
            catquizView.category_title = Category_title
            catquizView.level = level
            self.navigationController?.pushViewController(catquizView, animated: true)
        }else if ((level % 2) == 1){
            // Material
            let materialView = self.storyboard?.instantiateViewController(withIdentifier: "SB_MATERIAL") as! MaterialViewController
            materialView.category_id = Category_Id
            materialView.level = level
            self.navigationController?.pushViewController(materialView, animated: true)
        }else {
            // Practice quiz
            let practiceView = self.storyboard?.instantiateViewController(withIdentifier: "SB_PRACTICEQUIZ") as! PracticeQuizViewController
            practiceView.category_id = Category_Id
            practiceView.level = level
            self.navigationController?.pushViewController(practiceView, animated: true)
        }
    }
    
    func showMap(){

        checkAvailableItemsAndReload()
        showLevelBtns()
        
        scrollView.contentSize = contentView.frame.size
        scrollView.addSubview(contentView)
        scrollView.isScrollEnabled = true
        var bottomOffset = CGPoint.init()
        if doneLevels <= 8 {
            bottomOffset = CGPoint.init(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
        }else{
            bottomOffset = CGPoint.init(x: 0, y: 0)
        }
        scrollView.setContentOffset(bottomOffset, animated: true)
        
    }
    
    func checkAvailableItemsAndReload(){
        doneLevels = 0
        if(UserDefaults.standard.value(forKey:  "done_levels_categoryid_"+Category_Id!) != nil){
            doneLevels = UserDefaults.standard.integer(forKey:  "done_levels_categoryid_"+Category_Id!)
        }
    }
    
    func showLevelBtns(){
        for index in 1 ... totalLevelCountsPerCategory {
            let btnLevel = self.view.viewWithTag(index) as! UIButton
            btnLevel.isEnabled = true
            if(index <= doneLevels ){
                btnLevel.setBackgroundImage(UIImage.init(named: "level_done"), for: .normal)
                if(index < totalLevelCountsPerCategory){
                    btnLevel.setTitle(String(index), for: .normal)
                }else{
                    btnLevel.setTitle("FINAL", for: .normal)
                }
                if(index % 2 == 0){
                    // Practice Quiz
                    let totalCount = UserDefaults.standard.integer(forKey:  "total_"+Category_Id+"_level_"+String(index))
                    let correctCount = UserDefaults.standard.integer(forKey:  "correct_"+Category_Id+"_level_"+String(index))
                    let totalClicked = UserDefaults.standard.integer(forKey:  "testclicked_"+Category_Id+"_level_"+String(index))
                    var stars = 1
                    if(totalClicked <= correctCount + 1){
                        stars = 3
                    }else if (totalClicked <= correctCount + 3 ){
                        stars = 2
                    }
                    showStars(btn: btnLevel , count: stars)
                }
            }else if(index == doneLevels + 1){
                btnLevel.setBackgroundImage(UIImage.init(named: "level_current"), for: .normal)
                if(index < totalLevelCountsPerCategory){
                    btnLevel.setTitle(String(index), for: .normal)
                }else{
                    btnLevel.setTitle("FINAL", for: .normal)
                }
            }else {
                btnLevel.setBackgroundImage(UIImage.init(named: "level_empty"), for: .normal)
            }
        }
    }
    
    func showStars(btn:UIButton!, count:Int!){
        let starViewSize = CGSize.init(width: btn.frame.size.width, height: 24.0)
        let starView = UIView.init(frame: CGRect.init(x: btn.frame.origin.x+2, y: btn.frame.origin.y-starViewSize.height+2, width: starViewSize.width, height: starViewSize.height))
        let star1 = UIImageView.init(frame: CGRect.init(x: 2, y: 6, width: 16, height: 16))
        let star2 = UIImageView.init(frame: CGRect.init(x: starViewSize.width/2-8, y: 0, width: 16, height: 16))
        let star3 = UIImageView.init(frame: CGRect.init(x: starViewSize.width-20, y: 6, width: 16, height: 16))
        starView.addSubview(star1)
        starView.addSubview(star2)
        starView.addSubview(star3)
        if(count>=1){
            star1.image = UIImage.init(named: "level_star_fill")
        }else{
            star1.image = UIImage.init(named: "level_star_empty")
        }
        if(count>=2){
            star2.image = UIImage.init(named: "level_star_fill")
        }else{
            star2.image = UIImage.init(named: "level_star_empty")
        }
        if(count>=3){
            star3.image = UIImage.init(named: "level_star_fill")
        }else{
            star3.image = UIImage.init(named: "level_star_empty")
        }
        star1.contentMode = .scaleAspectFit
        star2.contentMode = .scaleAspectFit
        star3.contentMode = .scaleAspectFit
        contentView.addSubview(starView)
    }
    
}
