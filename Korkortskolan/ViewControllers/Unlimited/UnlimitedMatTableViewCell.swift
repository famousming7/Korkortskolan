//
//  UnlimitedMatTableViewCell
//  Retailshop
//
//  Created by Software on 12/13/17.
//  Copyright © 2017 Famousming Software. All rights reserved.
//

import UIKit
import LUExpandableTableView
final  class UnlimitedMatTableViewCell: LUExpandableTableViewSectionHeader {
    
    @IBOutlet weak var lbl_title: UILabel!

    override var isExpanded: Bool {
        didSet {
            // Change the title of the button when section header expand/collapse
        }
    }
    
    // MARK: - Base Class Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnLabel)))
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Private Functions
    
    @objc private func didTapOnLabel(_ sender: UIGestureRecognizer) {
        // Send the message to his delegate that was selected
        //delegate?.expandableSectionHeader(self, wasSelectedAtSection: section)
        delegate?.expandableSectionHeader(self, shouldExpandOrCollapseAtSection: section)
    }

}
