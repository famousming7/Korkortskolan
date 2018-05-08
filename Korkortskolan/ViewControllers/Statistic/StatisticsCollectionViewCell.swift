//
//  UnlimitedQuizRoomCollectionViewCell.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/12/07.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit

class StatisticsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_tests: UILabel!
    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var lbl_percent: UILabel!
    var m_arrQuiz = [Quiz]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        showProgressBar()
    }
    
    func showProgressBar(){
        var correctdCount = 0
        var totalCount = 1
        if(self.m_arrQuiz.count > 0) {
            totalCount = self.m_arrQuiz.count
        }
        for quiz in self.m_arrQuiz{
            if(quiz.isTested){
                let myAnswer = quiz.arrAnswers[quiz.selected_answer_index] as! String
                let correctAnswer = quiz.correct_answer as String
                if(myAnswer == correctAnswer){
                    correctdCount += 1
                }
            }
        }
        drawBackLine()
        drawLowCircle(c_val: Double(correctdCount), max_val: Double(totalCount))
        lbl_tests.text = String(correctdCount) + " TESTS"
        lbl_percent.text = String(Int(Double(correctdCount) / Double(totalCount) * 100)) + "%"
        if(correctdCount == 0){
            lbl_percent.textColor = UIColor.init(rgb: 0x5f5a58)
        }else{
            lbl_percent.textColor = UIColor.init(rgb: 0xffce02)
        }
    }
    
    
    func drawBackLine()
    {
        let c_val = 1.0
        let max_val = 1.0
        var endAngle = 0.0
        let startAngle = -Double.pi / 2
        endAngle = c_val/max_val * Double.pi * 2
        
        let circle_rect = viewCircle.frame
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: circle_rect.width/2,y: circle_rect.height/2), radius: CGFloat(circle_rect.height/2-10), startAngle: CGFloat(startAngle), endAngle:CGFloat(CGFloat(endAngle) + CGFloat(startAngle)), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.init(rgb: 0x5f5a58).cgColor
        //you can change the line width
        shapeLayer.lineWidth = 10
        self.viewCircle.layer.sublayers = nil
        self.viewCircle.layer.addSublayer(shapeLayer)
    }
    
    func drawLowCircle(c_val:Double, max_val:Double)
    {
        var endAngle = 0.0
        let startAngle = -Double.pi / 2
        endAngle = c_val/max_val * Double.pi * 2
        
        let circle_rect = viewCircle.frame
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: circle_rect.width/2,y: circle_rect.height/2), radius: CGFloat(circle_rect.height/2-10), startAngle: CGFloat(startAngle), endAngle:CGFloat(CGFloat(endAngle) + CGFloat(startAngle)), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.init(rgb: 0xffce02).cgColor
        //you can change the line width
        shapeLayer.lineWidth = 10
        self.viewCircle.layer.addSublayer(shapeLayer)
    }
}
