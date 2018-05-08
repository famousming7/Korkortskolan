//
//  CategoryCollectionViewCell.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/12/04.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import GTProgressBar
class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img_category: UIImageView!
    
    @IBOutlet weak var lbl_stepname: UILabel!
    @IBOutlet weak var progressBar: GTProgressBar!
    
    @IBOutlet weak var cView: UIView!
    var count:Int!
    var total: Int!
    //var progressBar:GTProgressBar!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cView.frame = self.frame
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func showProgress(countDone:Int, total:Int){
       
        progressBar.progress = CGFloat(Float(countDone) / Float(total))
        progressBar.barFillColor = UIColor.init(rgb: 0x4e4a4d)
        progressBar.barBackgroundColor = UIColor.white
        progressBar.barBorderWidth = 0
        progressBar.barFillInset = 0
        progressBar.displayLabel = false
        progressBar.progressLabelInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        progressBar.barMaxHeight = 10
    }
}
