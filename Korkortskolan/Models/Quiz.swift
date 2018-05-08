//
//  Quiz.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/22.
//  Copyright © 2017 Famousming. All rights reserved.
//

import Foundation
import Parse

class Quiz :NSObject,NSCoding
{
    var objectId :String!
    var category_id:String!
    var image:Data!
    var question:String!
    var explanation:String!
    var correct_answer:String!
    var arrAnswers:NSMutableArray!
    var selected_answer_index:Int!
    var isTested:Bool!
    var duration:Int!
    
    override init(){
    }
    init(withPFObj: PFObject){
        super.init()
        self.objectId =  withPFObj.objectId
        self.category_id =  withPFObj["category_id"] as? String
        self.question =  withPFObj["question"] as? String
        self.explanation =  withPFObj["explanation"] as? String
        self.correct_answer =  withPFObj["correct_answer"] as? String
        self.duration = 0
        self.image = Data.init()
        if let pfimage = withPFObj.value(forKey: "image") as? PFFile {
            pfimage.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let m_image = UIImage(data: imageData!)
                if m_image != nil {
                    self.image = UIImagePNGRepresentation(m_image!)
                }
            })
        }
        
        let m_arrAnswers = NSMutableArray.init()
        let wrong_answer_1 = withPFObj["wrong_answer_1"] as? String
        let wrong_answer_2 = withPFObj["wrong_answer_2"] as? String
        let wrong_answer_3 = withPFObj["wrong_answer_3"] as? String
        let wrong_answer_4 = withPFObj["wrong_answer_4"] as? String
        let wrong_answer_5 = withPFObj["wrong_answer_5"] as? String
        m_arrAnswers.add(correct_answer!)
        if(wrong_answer_1 != nil){
            m_arrAnswers.add(wrong_answer_1!)
        }
        if(wrong_answer_2 != nil){
            m_arrAnswers.add(wrong_answer_2!)
        }
        if(wrong_answer_3 != nil){
            m_arrAnswers.add(wrong_answer_3!)
        }
        if(wrong_answer_4 != nil){
            m_arrAnswers.add(wrong_answer_4!)
        }
        if(wrong_answer_5 != nil){
            m_arrAnswers.add(wrong_answer_5!)
        }
        self.arrAnswers = NSMutableArray.init(array: m_arrAnswers.shuffled())
        self.selected_answer_index = 0
        self.isTested = false
    }
    
    required init(coder aDecoder:NSCoder) {
        self.objectId = aDecoder.decodeObject(forKey: "objectId") as! String
        if((aDecoder.decodeObject(forKey: "category_id")) != nil){
            self.category_id = aDecoder.decodeObject(forKey: "category_id") as! String
        }
        self.question = aDecoder.decodeObject(forKey: "question") as! String
        self.explanation = aDecoder.decodeObject(forKey: "explanation") as! String
        self.correct_answer = aDecoder.decodeObject(forKey: "correct_answer") as! String
        self.image = aDecoder.decodeObject(forKey: "image") as! Data
        self.arrAnswers = aDecoder.decodeObject(forKey: "arrAnswers") as! NSMutableArray
        self.selected_answer_index = aDecoder.decodeObject(forKey: "selected_answer_index") as! Int
        self.duration = aDecoder.decodeObject(forKey: "duration") as! Int
        self.isTested = aDecoder.decodeObject(forKey: "isTested") as! Bool
    }
    
    func encode(with aCoder:NSCoder){
        aCoder.encode(objectId, forKey:"objectId")
        aCoder.encode(category_id, forKey:"category_id")
        aCoder.encode(question, forKey:"question")
        aCoder.encode(explanation, forKey:"explanation")
        aCoder.encode(correct_answer, forKey:"correct_answer")
        aCoder.encode(image, forKey:"image")
        aCoder.encode(arrAnswers, forKey:"arrAnswers")
        aCoder.encode(selected_answer_index, forKey:"selected_answer_index")
        aCoder.encode(isTested, forKey:"isTested")
        aCoder.encode(duration, forKey:"duration")
    }
    
    func setSelectedAnswer(index:Int){
        self.selected_answer_index = index
    }

}
