//
//  MoreViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/15.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
class MoreViewController: UIViewController {

    @IBOutlet weak var view_actcode: UIView!
    @IBOutlet weak var txt_code: UITextField!
    @IBOutlet weak var view_fullversion: UIView!
    var isShow = false
    var linkedInvitePage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view_actcode.alpha = 0.0
        if isFullVersion{
            view_fullversion.isHidden = true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        if(linkedInvitePage){
            linkedInvitePage = false
            let inviteView = self.storyboard?.instantiateViewController(withIdentifier: "SB_INVITE")
            self.navigationController?.pushViewController(inviteView!, animated: true)
        }
    }
    @IBAction func click_buyfullaccess(_ sender: Any) {
        let url = URL(string: "https://itunes.apple.com/us/app/vans-park-series/id1207703201?mt=8")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBAction func click_showcodeview(_ sender: Any) {
        if(UserDefaults.standard.bool(forKey: "isFullVersion")){
            let alert = UIAlertController(title: "Korkortskolan", message: "You already activated.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            isShow = !isShow
            if(isShow){view_actcode.alpha = 1.0}
            else{view_actcode.alpha = 0.0}
        }
    }
    
    @IBAction func click_activate(_ sender: Any) {
        if(txt_code.text!.count > 0){
            checkValidActivationCode(mycode: txt_code.text!)
        }else{
            Helper.showAlert(target: self, title: "", message: "Please input code")
        }
    }
    
    func checkValidActivationCode(mycode: String) {
        let onHub = MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = PFQuery(className: "Activation_Code")
        query.whereKey("code", equalTo: mycode)
        query.findObjectsInBackground(block: { (codes : [PFObject]?, error: Error!) -> Void in
            if error == nil {
               
                if(codes?.count == 0){
                    let alert = UIAlertController(title: "Korkortskolan", message: "Incorrect Activation Code?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let obj = codes![0]
                    let used = obj["used"] as! Bool
                    if(used){
                        Helper.showAlert(target: self, title: "Warning", message: "That Code is already used. Please use another one.")
                    }else{
                        obj["used"] = true
                        obj.saveInBackground()
                        self.view_actcode.endEditing(true)
                        isFullVersion = true
                        UserDefaults.standard.set(true, forKey: "isFullVersion")
                        self.view_actcode.isHidden = true
                        let alert = UIAlertController(title: "Korkortskolan", message: "Correct Activation Code.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler:nil))
                        self.present(alert, animated: true, completion: nil)
                        self.view_fullversion.isHidden = true
                    }
                    
                }
            }else{
                print(error)
            }
            onHub.hide(animated: true)
        })
    }
    
    @IBAction func click_settings(_ sender: Any) {
        let settingsView = self.storyboard?.instantiateViewController(withIdentifier: "SB_SETTINGS")
        self.navigationController?.pushViewController(settingsView!, animated: true)
    }
    
    @IBAction func click_contactus(_ sender: Any) {
        let contactView = self.storyboard?.instantiateViewController(withIdentifier: "SB_CONTACTUS")
        self.navigationController?.pushViewController(contactView!, animated: true)

    }
    
    @IBAction func click_rateus(_ sender: Any) {
        let appID = "959379869"
        let url = URL(string : "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)")
        UIApplication.shared.open(url!, options: [:], completionHandler: {action in
            let userDefults = UserDefaults.standard
            userDefults.setValue("rated", forKey: "rated")
            accessAppRated = 1
        })
    }
    
}
