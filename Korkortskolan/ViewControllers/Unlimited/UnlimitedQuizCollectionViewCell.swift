//
//  UnlimitedQuizCollectionViewCell.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/15.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import Parse
class UnlimitedQuizCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img_quiz: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    var info :PFObject!

    func showCell(){
        if let image_1 = info.value(forKey: "image") as? PFFile {
            image_1.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    DispatchQueue.main.async {
                        self.img_quiz.isHidden = false
                        self.img_quiz.image = image
                    }
                }else{
                    self.img_quiz.isHidden = true
                }
            })
        }
        self.lbl_title.text = info.object(forKey: "quiz_title") as? String
    }
}
