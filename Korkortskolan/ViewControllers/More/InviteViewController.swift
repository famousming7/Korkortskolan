//
//  InviteViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/16.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
