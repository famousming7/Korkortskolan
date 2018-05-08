//
//  Global.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/13.
//  Copyright © 2017 Famousming. All rights reserved.
//

import Foundation
import Parse
var arrCategories = [PFObject]()
var arrCategoryDetails = [PFObject]()
var arrMaterials = [PFObject]()
var arrPracticeQuiz = [PFObject]()
var arrCategoryQuiz = [PFObject]()
var arrUnlimitedQuiz = [PFObject]()
var arrFaqs = [PFObject]()
var isFullVersion = false
var isOpened = false

var accessAppRated = 0              // 0 or 1
var activationCode = "mycode"

var totalLevelCountsPerCategory = 15
var perQuizSeconds = 30

//
let colorAnswerNormal = UIColor.init(rgb: 0x464443)
let colorAnswerCorrect = UIColor.init(rgb: 0x66bf56)
let colorAnswerWrong = UIColor.init(rgb: 0xdb4a44)
let colorQuizPassed = UIColor.init(rgb: 0x82B85B)
let colorQuizFailed = UIColor.init(rgb: 0xe6513e)
let quizPassRate = 0.8 // 80 Percent

// Done rate
//rated      String "rated"

// Done Category Items.
//total_categoryid_(category_id)   integer
//done_categoryid_(category_id)    integer

// Category Quiz Results
//category_quiz_res_(category_id)

