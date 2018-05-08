//
//  MaterialViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/15.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

class MaterialViewController: UIViewController {

    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    
    var category_id:String!
    var level:Int!
    var m_arrMaterial:PFObject!
    var contents : [MaterialObject] = []
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
        if(UserDefaults.standard.integer(forKey: "done_levels_categoryid_" + category_id) < level)
        {
            UserDefaults.standard.set(level, forKey: "done_levels_categoryid_" + category_id )
        }
        self.navigationController?.popViewController(animated: true)        
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getDBMaterial(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = PFQuery(className: "Material_Detail")
        query.whereKey("category_id", equalTo: category_id)
        query.whereKey("level", equalTo: String(level))
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
        
        lbl_title.text = m_arrMaterial["title"] as? String
        
        if(m_arrMaterial == nil){
            Helper.showAlert(target: self, title:"Warning!" , message: "Please wait. This Category Quiz was not uploaded.", completion:{
                self.navigationController?.popViewController(animated: true)
            })
        }else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            for index in 1...10 {
                
                let text_key = "text_\(index)"
                let title_key = "text_\(index)_title"
                let image_key = "image_\(index)"
                
                let text  = m_arrMaterial[text_key] as? String ?? ""
                let title = m_arrMaterial[title_key] as? String ?? ""
                let image = m_arrMaterial.value(forKey: image_key) as? PFFile
                if image != nil || text != "" || title != "" {
                    let object = MaterialObject.init(title: title, content: text, imagePF: image)
                    self.contents.append(object)
                }
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tblView.reloadData()
        }
    }

}

extension MaterialViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count == 0 ? 0 : self.contents.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < self.contents.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_materialdetail", for: indexPath) as! MaterialDetailContentCell
            cell.bindData(object: self.contents[indexPath.row])
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_materialbtn", for: indexPath) as! MaterialDetailBtnCell
            
            return cell
        }
    }
}

//            flag_1 = false
//            flag_2 = false
//            flag_3 = false
//            if let image_1 = m_arrMaterial.value(forKey: "image_1") as? PFFile {
//                image_1.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
//
//                    if error == nil {
//                        let image = UIImage(data: imageData!)
//                        if image != nil {
//                                DispatchQueue.main.async {
//                                    self.img_1.image = image
//                                }
//                        }else{
//                            self.img_1.isHidden = true
//                        }
//                    }
//                    self.flag_1 = true
//                    self.checkAllLoaded()
//                })
//            }else{
//                flag_1 = true
//                self.img_1.frame = CGRect.init(origin: self.img_1.frame.origin, size: CGSize.zero)
//            }
//            if let image_2 = m_arrMaterial.value(forKey: "image_2") as? PFFile {
//                image_2.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
//
//                    if error == nil {
//                        let image = UIImage(data: imageData!)
//                        if image != nil {
//                            let image = UIImage(data: imageData!)
//                            DispatchQueue.main.async {
//                                self.img_2.image = image
//                            }
//                        }else{
//                            self.img_2.isHidden = true
//                        }
//                    }
//                    self.flag_2 = true
//                    self.checkAllLoaded()
//                })
//            }else{
//                flag_2 = true
//                self.img_2.frame = CGRect.init(origin: self.img_2.frame.origin, size: CGSize.zero)
//            }
//            if let image_3 = m_arrMaterial.value(forKey: "image_3") as? PFFile {
//                image_3.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
//
//                    if error == nil {
//                        let image = UIImage(data: imageData!)
//                        if image != nil {
//                            let image = UIImage(data: imageData!)
//                            DispatchQueue.main.async {
//                                self.img_3.image = image
//                            }
//                        }else{
//                            self.img_3.isHidden = true
//                        }
//                    }
//                    self.flag_3 = true
//                    self.checkAllLoaded()
//                })
//            }else{
//                flag_3 = true
//                self.img_3.frame = CGRect.init(origin: self.img_3.frame.origin, size: CGSize.zero)
//            }
//            self.checkAllLoaded()
//        }
//    }
//    func checkAllLoaded(){
//        if(flag_1 && flag_2 && flag_3){
//            DispatchQueue.main.async {
//                MBProgressHUD.hide(for: self.view, animated: true)
//                self.sizeFitDetail()
//            }
//        }
//    }
//    func sizeFitDetail(){
//        lbl_title.text = m_arrMaterial["title"] as? String
////        lbl_1.text = m_arrMaterial["text_1"] as? String
////        lbl_2.text = m_arrMaterial["text_2"] as? String
////        lbl_3.text = m_arrMaterial["text_3"] as? String
//        showLabelText(lbl: lbl_1, text: (m_arrMaterial["text_1"] as? String ?? "")!)
//        showLabelText(lbl: lbl_2, text: (m_arrMaterial["text_2"] as? String ?? "")!)
//        showLabelText(lbl: lbl_3, text: (m_arrMaterial["text_3"] as? String ?? "")!)
//        showLabelText(lbl: lbl_1_title, text: (m_arrMaterial["text_1_title"] as? String ?? "")!)
//        showLabelText(lbl: lbl_2_title, text: (m_arrMaterial["text_2_title"] as? String ?? "")!)
//        showLabelText(lbl: lbl_3_title, text: (m_arrMaterial["text_3_title"] as? String ?? "")!)
//
//        let margin = 20.0
//        lbl_1_title.sizeToFit()
//        lbl_1_title.frame = CGRect.init(origin: CGPoint.init(x: 0, y: img_1.frame.origin.y+img_1.frame.size.height+CGFloat(margin)), size: lbl_1_title.frame.size)
//        lbl_1.sizeToFit()
//        lbl_1.frame = CGRect.init(origin: CGPoint.init(x: 0, y: lbl_1_title.frame.origin.y+lbl_1_title.frame.size.height+CGFloat(margin)), size: lbl_1.frame.size)
//        img_2.frame = CGRect.init(origin: CGPoint.init(x: 0, y: lbl_1.frame.origin.y+lbl_1.frame.size.height+CGFloat(margin)), size: img_2.frame.size)
//
//        lbl_2_title.sizeToFit()
//        lbl_2_title.frame = CGRect.init(origin: CGPoint.init(x: 0, y: img_2.frame.origin.y+img_2.frame.size.height+CGFloat(margin)), size: lbl_2_title.frame.size)
//        lbl_2.sizeToFit()
//        lbl_2.frame = CGRect.init(origin: CGPoint.init(x: 0, y: lbl_2_title.frame.origin.y+lbl_2_title.frame.size.height+CGFloat(margin)), size: lbl_2.frame.size)
//        img_3.frame = CGRect.init(origin: CGPoint.init(x: 0, y: lbl_2.frame.origin.y+lbl_2.frame.size.height+CGFloat(margin)), size: img_3.frame.size)
//
//        lbl_3_title.sizeToFit()
//        lbl_3_title.frame = CGRect.init(origin: CGPoint.init(x: 0, y: img_3.frame.origin.y+img_3.frame.size.height+CGFloat(margin)), size: lbl_3_title.frame.size)
//        lbl_3.sizeToFit()
//        lbl_3.frame = CGRect.init(origin: CGPoint.init(x: 0, y: lbl_3_title.frame.origin.y+lbl_3_title.frame.size.height+CGFloat(margin)), size: lbl_3.frame.size)
//
//        view_content.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: view_content.frame.size.width, height: lbl_3.frame.origin.y+lbl_3.frame.size.height+CGFloat(margin)*6+btn_done.frame.size.height))
//
//        scrollView.contentSize = view_content.frame.size
//        scrollView.addSubview(view_content)
//        scrollView.isScrollEnabled = true
//    }


