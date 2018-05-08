//
//  UnlimitedMatViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/12/13.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import MBProgressHUD
import LUExpandableTableView
import Parse
class UnlimitedMatViewController: UIViewController,LUExpandableTableViewDelegate,LUExpandableTableViewDataSource {

    fileprivate let sectionHeaderReuseIdentifier = "MySectionHeader"
    @IBOutlet weak var tbl_categories: LUExpandableTableView!
    
    var arrCats = [PFObject]()
    var arrChapters :NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbl_categories.register(UINib(nibName: "UnlimitedMatTableViewCell", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: sectionHeaderReuseIdentifier)
        self.tbl_categories.expandableTableViewDelegate = self
        self.tbl_categories.expandableTableViewDataSource = self
        arrChapters = NSMutableDictionary.init()
        getDBInfo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDBInfo(){
            let oneHub = MBProgressHUD.showAdded(to: self.view, animated: true)
            let query = PFQuery(className: "Unlimited_Materials")
            query.order(byAscending: "order")
            query.findObjectsInBackground(block: { (categories : [PFObject]?, error: Error!) -> Void in
                if error == nil {
                    self.arrCats = categories!
                    if(self.arrCats.count == 0){
                        Helper.showAlert(target: self, title:"Warning!" , message: "Please wait. Content does not uploaded.")
                    }
                    else{
                        self.getChapters()
                    }
                }else{
                    print(error)
                }
                oneHub.hide(animated: true)
            })
    }
    func getChapters(){
        for cat in self.arrCats{
            if((cat["mat_id"]) != nil){
                let oneHUB = MBProgressHUD.showAdded(to: self.view, animated: true)
                let query = PFQuery(className: "Unlimited_Materials_Chapter")
                query.order(byAscending: "order")
                query.whereKey("mat_id", equalTo: cat["mat_id"])
                query.findObjectsInBackground(block: { (chapters : [PFObject]?, error: Error!) -> Void in
                    if error == nil {
                            self.arrChapters.setObject(chapters!, forKey: cat["mat_id"] as! String as NSCopying)
                    }else{
                        print(error)
                    }
                    oneHUB.hide(animated: true)
                    self.tbl_categories.reloadData()
                })
            }
        }
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Expandable View Delegate
    func numberOfSections(in expandableTableView: LUExpandableTableView) -> Int {
        return self.arrCats.count
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrCats.count - 1 >= section{
            let cat = self.arrCats[section]
            if(self.arrChapters.object(forKey: cat["mat_id"]) != nil){
                let chapters = self.arrChapters.object(forKey: cat["mat_id"]) as! [PFObject]
                return chapters.count
            }
            return 0
        }else{
            return 0
        }
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let ynSliderCell = expandableTableView.dequeueReusableCell(withIdentifier: "cell_material") as! UnlimitedMatExpandTableViewCell
        let cat = self.arrCats[indexPath.section]
        if(self.arrChapters.object(forKey: cat["mat_id"]) != nil){
            let chapters = self.arrChapters.object(forKey: cat["mat_id"]) as! [PFObject]
            let chapt = chapters[indexPath.row]
            ynSliderCell.lbl_title.text = chapt["title"] as? String
        }
        return ynSliderCell
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, sectionHeaderOfSection section: Int) -> LUExpandableTableViewSectionHeader {
        let title_cell = expandableTableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderReuseIdentifier) as? UnlimitedMatTableViewCell
        let cat = self.arrCats[section]
        title_cell?.lbl_title.text = cat["title"] as? String ?? ""
        return title_cell!
    }
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        print("Did select cell at section \(indexPath.section) row \(indexPath.row)")
        let unlimtedMatDetailView = self.storyboard?.instantiateViewController(withIdentifier: "SB_UNLIMITEDMATDETAIL") as! UnlimitedMatDetailViewController
        let cat = self.arrCats[indexPath.section]
        let chapters = self.arrChapters.object(forKey: cat["mat_id"]) as! [PFObject]
        let chapt = chapters[indexPath.row]
        unlimtedMatDetailView.category_id = cat["mat_id"] as! String
        let level = chapt["order"] as! String
        unlimtedMatDetailView.level = Int(level)
        self.navigationController?.pushViewController(unlimtedMatDetailView, animated: true)
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectSectionHeader sectionHeader: LUExpandableTableViewSectionHeader, atSection section: Int) {
        print("Did select section header at section \(section)")
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Will display cell at section \(indexPath.section) row \(indexPath.row)")
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplaySectionHeader sectionHeader: LUExpandableTableViewSectionHeader, forSection section: Int) {
        print("Will display section header for section \(section)")
    }
}
