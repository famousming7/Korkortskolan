//
//  MaterialDetailContentCell.swift
//  Korkortskolan
//
//  Created by Software on 3/16/18.
//  Copyright © 2018 Famousming. All rights reserved.
//

import UIKit
import Parse

class MaterialDetailContentCell: UITableViewCell {

    @IBOutlet weak var matImage: UIImageView!
    @IBOutlet weak var matTitleLabel: UILabel!
    @IBOutlet weak var matDetailLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var detailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindData(object : MaterialObject) {
        
        if object.imagePF != nil{
            imageHeightConstraint.constant = 172
            self.loadImage(file: object.imagePF!)
        } else {
            imageHeightConstraint.constant = 0
        }
        
        showLabelText(lbl: matTitleLabel, text: object.title)
        if object.title == "" {
            titleLabelTopConstraint.constant = 0
        } else {
            titleLabelTopConstraint.constant = 20
        }
        
        showLabelText(lbl: matDetailLabel, text: object.content)
        if object.content == "" {
            detailTopConstraint.constant = 0
        } else {
            detailTopConstraint.constant = 20
        }
        
        if object.title == "" && object.content == "" {
            bottomConstraint.constant = 0            
        } else {
            bottomConstraint.constant = 20
        }
        
    }
    
    func loadImage(file : PFFile) {
        
        file.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
            
            if error == nil {
                let img = UIImage(data: imageData!)
                if img != nil {
                    self.matImage.image = img
                }else{
                    self.imageHeightConstraint.constant = 0
                }
            }
        })
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

}
