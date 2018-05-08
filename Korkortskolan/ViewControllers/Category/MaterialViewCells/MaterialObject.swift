//
//  MaterialObject.swift
//  Korkortskolan
//
//  Created by Software on 3/16/18.
//  Copyright © 2018 Famousming. All rights reserved.
//

import Foundation
import UIKit

import Parse

class MaterialObject : NSObject {
    
    var title : String
    var content : String
    var image : UIImage?
    var imagePF : PFFile?
    
    init(title : String, content : String, imagePF: PFFile?) {
        
        
        self.title = title
        self.content = content
        self.imagePF = imagePF
        super.init()
    }
}
