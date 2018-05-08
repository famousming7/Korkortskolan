//
//  StatisticTitleCollectionViewCell.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/12/15.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import GTProgressBar

class StatisticTitleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl_count: UILabel!    
    @IBOutlet weak var progressView: UIView!
    var progressBar:GTProgressBar!
    var count: Int! = 0
    var total: Int! = 1
    override func awakeFromNib() {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        showProgress(countDone: count, total: total)
    }
    func showProgress(countDone:Int, total:Int){
        if (progressBar != nil) { progressBar.removeFromSuperview()}
        progressBar = GTProgressBar(frame: CGRect.init(origin: CGPoint.zero, size: self.progressView.frame.size))
        self.progressView.addSubview(progressBar)
        progressBar.progress = CGFloat(Float(countDone) / Float(total))
        progressBar.barFillColor = UIColor.init(rgb: 0xffcf00)
        progressBar.barBackgroundColor = UIColor.init(rgb:0x4e4a4c)
        progressBar.barBorderWidth = 0
        progressBar.barFillInset = 0
        progressBar.displayLabel = false
        progressBar.progressLabelInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        progressBar.barMaxHeight = 14
    }
}
