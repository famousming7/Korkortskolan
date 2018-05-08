//
//  ContactusViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/16.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import LUExpandableTableView
import MBProgressHUD
import Parse
class ContactusViewController: UIViewController ,LUExpandableTableViewDataSource,LUExpandableTableViewDelegate{

    fileprivate let sectionHeaderReuseIdentifier = "MySectionHeader"
     @IBOutlet weak var m_tableview: LUExpandableTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        m_tableview.register(UINib(nibName: "MyExpandableTableViewSectionHeader", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: sectionHeaderReuseIdentifier)
        m_tableview.expandableTableViewDataSource = self
        m_tableview.expandableTableViewDelegate = self
        getDBCategoryDetails()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickEmailus(_ sender: Any) {
        let email = "test@test.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    func getDBCategoryDetails(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = PFQuery(className: "Faqs")
        query.order(byAscending: "createdAt")
        query.findObjectsInBackground(block: { (category_details : [PFObject]?, error: Error!) -> Void in
            if error == nil {
                arrFaqs = category_details!
                if(arrFaqs.count == 0){
                    Helper.showAlert(target: self, title:"Warning!" , message: "Please wait. Unlimited Quiz was not uploaded.")
                }
                DispatchQueue.main.async {
                    self.m_tableview.reloadData()
                }
            }else{
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGSize{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width:
            width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.size
    }
    
    
    func numberOfSections(in expandableTableView: LUExpandableTableView) -> Int {
        return arrFaqs.count
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: "cell_detail") as? ContactExpandTableViewCell else {
            assertionFailure("Cell shouldn't be nil")
            return UITableViewCell()
        }
        let faq =  arrFaqs[indexPath.section]
        cell.lbl_msg.text = faq["answer"] as? String
        let lbl_size = heightForLabel(text: (faq["answer"] as? String)!, font: UIFont.init(name: "Geomanist-Medium", size: 15.0)!, width: m_tableview.frame.size.width)
        cell.lbl_msg.frame = CGRect(origin: CGPoint.init(x: 0, y: 0), size: lbl_size)
        cell.lbl_msg.sizeToFit()
        return cell
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, sectionHeaderOfSection section: Int) -> LUExpandableTableViewSectionHeader {
        let sectionHeader = expandableTableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderReuseIdentifier) as? MyExpandableTableViewSectionHeader
        let faq =  arrFaqs[section]
        sectionHeader?.label.text = faq["question"] as? String
        return sectionHeader!
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let faq = arrFaqs[indexPath.section]
        let view_height = heightForLabel(text: (faq["answer"] as? String)!, font: UIFont.init(name: "Geomanist-Medium", size: 15.0)!, width: m_tableview.frame.size.width).height
        return view_height + 10
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
        /// Returning `UITableViewAutomaticDimension` value on iOS 9 will cause reloading all cells due to an iOS 9 bug with automatic dimensions
        
        return 60
    }
    
    // MARK: - Optional
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        print("Did select cell at section \(indexPath.section) row \(indexPath.row)")
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
