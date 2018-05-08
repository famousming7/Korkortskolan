//
//  CategoryTableViewCell.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/11.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import GTProgressBar
class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var progressView: UIView!
    var progressBar:GTProgressBar!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progressBar = GTProgressBar(frame: CGRect.init(origin: CGPoint.zero, size: self.progressView.frame.size))
        self.progressView.addSubview(progressBar)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showProgress(countDone:Int, total:Int){
        
        progressBar.progress = CGFloat(Float(countDone) / Float(total))
        progressBar.barBorderColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.barFillColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.barBackgroundColor = UIColor(red:0.77, green:0.93, blue:0.78, alpha:1.0)
        progressBar.barBorderWidth = 1
        progressBar.barFillInset = 2
        progressBar.labelTextColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.progressLabelInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        progressBar.font = UIFont.boldSystemFont(ofSize: 18)
        progressBar.labelPosition = GTProgressBarLabelPosition.right
        progressBar.barMaxHeight = 12
    }
}
