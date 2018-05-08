//
//  QuizResultViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/12/07.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit

class QuizResultViewController: UIViewController {

    @IBOutlet weak var lbl_score: UILabel!
    @IBOutlet weak var lbl_desc: UILabel!
    @IBOutlet weak var lbl_scoreback: UILabel!
    
    @IBOutlet weak var btn_gothrough: UIButton!
    @IBOutlet weak var btn_goto: UIButton!
    var category_id:String!
    var isUnlimited = false
    var m_arrQuiz = [Quiz]()
    var isPassed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        m_arrQuiz = []
        getQuizList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(isUnlimited){
//            btn_gothrough.isHidden = true
        }
    }
    @IBAction func clickBack(_ sender: Any) {
        goBack()
    }
    
    @IBAction func clickGotoThrough(_ sender: Any) {
        if(!isUnlimited){
            let reView = self.storyboard?.instantiateViewController(withIdentifier: "SB_CATEGORYQUIZREVIEW") as! CategoryQuizReViewController
            reView.category_id = category_id
            self.navigationController?.pushViewController(reView, animated: true)
        }else{
            let reView = self.storyboard?.instantiateViewController(withIdentifier: "SB_UNLIMITEDQUIZREVIEW") as! UnlimitedQuizReViewController
            reView.unlimited_id = category_id
            self.navigationController?.pushViewController(reView, animated: true)
        }
    }
    
    @IBAction func clickGoToSteop(_ sender: Any) {
        goBack()
    }
    
    func goBack(){
        if(!isUnlimited){
            if isPassed {
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                for controller in (self.navigationController?.viewControllers)! {
                    if controller.isKind(of: CategoryDetailViewController.self){
                        self.navigationController?.popToViewController(controller, animated: true)
                        return
                    }
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }else{
            for controller in (self.navigationController?.viewControllers)! {
                if controller.isKind(of: UnlimitedQuizViewController.self){
                    self.navigationController?.popToViewController(controller, animated: true)
                    return
                }
            }
        }
    }
    
    func getQuizList(){
        if isUnlimited{
            if let data = UserDefaults.standard.object(forKey: "unlimited_quiz_res_" + category_id) as? NSData {
                self.m_arrQuiz = (NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [Quiz])!
            }
        }else{
            if let data = UserDefaults.standard.object(forKey: "category_quiz_res_" + category_id) as? NSData {
                self.m_arrQuiz = (NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [Quiz])!
            }
        }
        
        if(self.m_arrQuiz.count == 0){
            Helper.showAlert(target: self, title:"Warning!" , message: "There isn't Quiz Result.")
        }else{
            showScore()
        }
    }
    func showScore(){
        var correctdCount = 0
        for quiz in self.m_arrQuiz{
            if(quiz.isTested){
                let myAnswer = quiz.arrAnswers[quiz.selected_answer_index] as! String
                let correctAnswer = quiz.correct_answer as String
                if(myAnswer == correctAnswer){
                    correctdCount += 1
                }
            }
        }
        lbl_score.text = String(correctdCount)
        let passCount = round(Double(self.m_arrQuiz.count) * quizPassRate)
        if(correctdCount >= Int(passCount)){
            // Passed
            isPassed = true
            lbl_scoreback.backgroundColor = colorQuizPassed
            lbl_desc.text = "CONGRATULATIONS\n YOU MADE IT!"
            if !isUnlimited{
                UserDefaults.standard.set(true, forKey: "done_quiz_categoryid_"+category_id)
            }
            btn_goto.setTitle("GO TO HOME", for: .normal)
        }else{
            // Failed
            isPassed = false
            lbl_scoreback.backgroundColor = colorQuizFailed
            lbl_desc.text = "OH NO\n YOU DIDN'T PASS!"
            if !isUnlimited{
                UserDefaults.standard.set(true, forKey: "done_quiz_categoryid_"+category_id)
            }
            btn_goto.setTitle("GO TO STEPS", for: .normal)
        }
    }
}
