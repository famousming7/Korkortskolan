//
//  UnlimitedMatDetailViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/12/13.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse
class UnlimitedMatDetailViewController: UIViewController {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbl_1: UILabel!
    @IBOutlet weak var img_1: UIImageView!
    @IBOutlet weak var lbl_2: UILabel!
    @IBOutlet weak var img_2: UIImageView!
    @IBOutlet weak var lbl_3: UILabel!
    @IBOutlet weak var img_3: UIImageView!
    @IBOutlet weak var btn_done: UIButton!
    @IBOutlet weak var lbl_1_title: UILabel!
    @IBOutlet weak var lbl_2_title: UILabel!
    @IBOutlet weak var lbl_3_title: UILabel!
    
    var category_id:String!
    var level:Int!
    var m_arrMaterial:PFObject!
    var flag_1 = false
    var flag_2 = false
    var flag_3 = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getDBMaterial()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickDoneReading(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getDBMaterial(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = PFQuery(className: "Unlimited_Materials_Chapter")
        query.whereKey("mat_id", equalTo: category_id)
        query.whereKey("order", equalTo: String(level))
        query.findObjectsInBackground(block: { (materials : [PFObject]?, error: Error!) -> Void in
            if error == nil {
                if(materials != nil){
                    if(materials!.count > 0)
                    {
                        self.m_arrMaterial = materials![0]
                    }
                }
                DispatchQueue.main.async {
                    self.showMaterialInfo()
                }
            }else{
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func showMaterialInfo(){
        if(m_arrMaterial == nil){
            Helper.showAlert(target: self, title:"Warning!" , message: "Please wait. This Category Quiz was not uploaded.", completion:{
                self.navigationController?.popViewController(animated: true)
            })
        }else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            flag_1 = false
            flag_2 = false
            flag_3 = false
            if let image_1 = m_arrMaterial.value(forKey: "image_1") as? PFFile {
                image_1.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    
                    if error == nil {
                        let image = UIImage(data: imageData!)
                        if image != nil {
                            DispatchQueue.main.async {
                                self.img_1.image = image
                            }
                        }else{
                            self.img_1.isHidden = true
                        }
                    }
                    self.flag_1 = true
                    self.checkAllLoaded()
                })
            }else{
                flag_1 = true
                self.img_1.frame = CGRect.init(origin: self.img_1.frame.origin, size: CGSize.zero)
            }
            if let image_2 = m_arrMaterial.value(forKey: "image_2") as? PFFile {
                image_2.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    
                    if error == nil {
                        let image = UIImage(data: imageData!)
                        if image != nil {
                            let image = UIImage(data: imageData!)
                            DispatchQueue.main.async {
                                self.img_2.image = image
                            }
                        }else{
                            self.img_2.isHidden = true
                        }
                    }
                    self.flag_2 = true
                    self.checkAllLoaded()
                })
            }else{
                flag_2 = true
                self.img_2.frame = CGRect.init(origin: self.img_2.frame.origin, size: CGSize.zero)
            }
            if let image_3 = m_arrMaterial.value(forKey: "image_3") as? PFFile {
                image_3.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    
                    if error == nil {
                        let image = UIImage(data: imageData!)
                        if image != nil {
                            let image = UIImage(data: imageData!)
                            DispatchQueue.main.async {
                                self.img_3.image = image
                            }
                        }else{
                            self.img_3.isHidden = true
                        }
                    }
                    self.flag_3 = true
                    self.checkAllLoaded()
                })
            }else{
                flag_3 = true
                self.img_3.frame = CGRect.init(origin: self.img_3.frame.origin, size: CGSize.zero)
            }
            self.checkAllLoaded()
        }
    }
    func checkAllLoaded(){
        if(flag_1 && flag_2 && flag_3){
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.sizeFitDetail()
            }
        }
    }
    func showLabelText( lbl:UILabel, text:String){
        let stringValue = text
        let attrString = NSMutableAttributedString(string: stringValue)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        //        style.minimumLineHeight = 20 // change line spacing between each line like 30 or 40
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: stringValue.count))
        lbl.attributedText = attrString
    }
    
    func sizeFitDetail(){
        lbl_title.text = m_arrMaterial["title"] as? String
        //        lbl_1.text = m_arrMaterial["text_1"] as? String
        //        lbl_2.text = m_arrMaterial["text_2"] as? String
        //        lbl_3.text = m_arrMaterial["text_3"] as? String
        showLabelText(lbl: lbl_1, text: (m_arrMaterial["text_1"] as? String ?? "")!)
        showLabelText(lbl: lbl_2, text: (m_arrMaterial["text_2"] as? String ?? "")!)
        showLabelText(lbl: lbl_3, text: (m_arrMaterial["text_3"] as? String ?? "")!)
        showLabelText(lbl: lbl_1_title, text: (m_arrMaterial["text_1_title"] as? String ?? "")!)
        showLabelText(lbl: lbl_2_title, text: (m_arrMaterial["text_2_title"] as? String ?? "")!)
        showLabelText(lbl: lbl_3_title, text: (m_arrMaterial["text_3_title"] as? String ?? "")!)
        
        let margin = 20.0
        lbl_1_title.sizeToFit()
        lbl_1_title.frame = CGRect.init(origin: CGPoint.init(x: 0, y: img_1.frame.origin.y+img_1.frame.size.height+CGFloat(margin)), size: lbl_1_title.frame.size)
        lbl_1.sizeToFit()
        lbl_1.frame = CGRect.init(origin: CGPoint.init(x: 0, y: lbl_1_title.frame.origin.y+lbl_1_title.frame.size.height+CGFloat(margin)), size: lbl_1.frame.size)
        img_2.frame = CGRect.init(origin: CGPoint.init(x: 0, y: lbl_1.frame.origin.y+lbl_1.frame.size.height+CGFloat(margin)), size: img_2.frame.size)
        
        lbl_2_title.sizeToFit()
        lbl_2_title.frame = CGRect.init(origin: CGPoint.init(x: 0, y: img_2.frame.origin.y+img_2.frame.size.height+CGFloat(margin)), size: lbl_2_title.frame.size)
        lbl_2.sizeToFit()
        lbl_2.frame = CGRect.init(origin: CGPoint.init(x: 0, y: lbl_2_title.frame.origin.y+lbl_2_title.frame.size.height+CGFloat(margin)), size: lbl_2.frame.size)
        img_3.frame = CGRect.init(origin: CGPoint.init(x: 0, y: lbl_2.frame.origin.y+lbl_2.frame.size.height+CGFloat(margin)), size: img_3.frame.size)
        
        lbl_3_title.sizeToFit()
        lbl_3_title.frame = CGRect.init(origin: CGPoint.init(x: 0, y: img_3.frame.origin.y+img_3.frame.size.height+CGFloat(margin)), size: lbl_3_title.frame.size)
        lbl_3.sizeToFit()
        lbl_3.frame = CGRect.init(origin: CGPoint.init(x: 0, y: lbl_3_title.frame.origin.y+lbl_3_title.frame.size.height+CGFloat(margin)), size: lbl_3.frame.size)
        
        view_content.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: view_content.frame.size.width, height: lbl_3.frame.origin.y+lbl_3.frame.size.height+CGFloat(margin)*6+btn_done.frame.size.height))
        
        scrollView.contentSize = view_content.frame.size
        scrollView.addSubview(view_content)
        scrollView.isScrollEnabled = true
    }

    
}
