//
//  PracticeQuizTableViewCell.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/15.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit

class PracticeQuizTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_answer: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var lbl_status_back: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
