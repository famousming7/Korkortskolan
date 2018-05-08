//
//  CategoryQuizReViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/22.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
class CategoryQuizReViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_quiz: UIImageView!
    @IBOutlet weak var lbl_explanation: UILabel!
    @IBOutlet weak var lbl_question: UILabel!
    @IBOutlet weak var tbl_answers: UITableView!
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var btn_previous: UIButton!
    @IBOutlet weak var btn_previous_rect: UIButton!
    @IBOutlet weak var btn_next_rect: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var tbl_cell_height = 60
    var category_id:String!
    var m_arrQuiz = [Quiz]()
    var m_arrAnswers:NSMutableArray!
    var c_QuizIndex = 0
    var c_CorrectAnswer:String!
    var c_myAnswer:String!
    var countTimer = 0
    let statusString = ["A","B","C","D","E","F","G"]
    override func viewDidLoad() {
        super.viewDidLoad()
        m_arrAnswers = NSMutableArray.init()
        getQuizList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {

    }
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickNext(_ sender: Any) {
        c_QuizIndex = c_QuizIndex + 1
        m_arrAnswers = []
        showQuizInfo()
    }
    
    @IBAction func clickBefore(_ sender: Any) {
        c_QuizIndex = c_QuizIndex - 1
        m_arrAnswers = []
        showQuizInfo()
    }


    func getQuizList(){
        if let data = UserDefaults.standard.object(forKey: "category_quiz_res_" + category_id) as? NSData {
            self.m_arrQuiz = (NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [Quiz])!
        }
        
        if(self.m_arrQuiz.count == 0){
            Helper.showAlert(target: self, title:"Warning!" , message: "Please wait. Category Quizes were not uploaded.")
        }
        self.showQuizInfo()
    }
    
    func showQuizInfo(){
        if(m_arrQuiz.count == 0){
            
        }
        else if(c_QuizIndex + 1 <= m_arrQuiz.count){
            //show Quiz
            if c_QuizIndex == 0{
                btn_previous.isEnabled = false
                btn_previous_rect.isEnabled = false
            }else{
                btn_previous.isEnabled = true
                btn_previous_rect.isEnabled = true
            }
        
            if(c_QuizIndex == m_arrQuiz.count - 1){
                btn_next.isEnabled = false
                btn_next_rect.isEnabled = false
            }else{
                btn_next.isEnabled = true
                btn_next_rect.isEnabled = true
            }
                
            let quiz = m_arrQuiz[c_QuizIndex]
            lbl_title.text = String(c_QuizIndex+1) + " / " + String(m_arrQuiz.count)
            lbl_question.text = quiz.question
            lbl_explanation.text = quiz.explanation
            lbl_explanation.sizeToFit()
            self.img_quiz.image = UIImage.init(data: quiz.image)
            c_CorrectAnswer = quiz.correct_answer
            m_arrAnswers = quiz.arrAnswers
            c_myAnswer = m_arrAnswers.object(at: quiz.selected_answer_index) as! String
            self.tbl_answers.reloadData()
            
            let tbl_height = m_arrAnswers.count * tbl_cell_height + 2
            tbl_answers.frame = CGRect.init(origin: tbl_answers.frame.origin, size: CGSize.init(width: Int(tbl_answers.frame.size.width), height: tbl_height))
            lbl_explanation.frame = CGRect.init(x: lbl_explanation.frame.origin.x, y: tbl_answers.frame.origin.y + CGFloat(tbl_height) + 10, width: lbl_explanation.frame.width, height: lbl_explanation.frame.height)
            contentView.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: contentView.frame.width, height: lbl_explanation.frame.origin.y + lbl_explanation.frame.size.height + btn_next_rect.frame.height+20) )
            
            scrollView.contentSize = contentView.frame.size
            scrollView.addSubview(contentView)
            scrollView.isScrollEnabled = true
            
            let  bottomOffset = CGPoint.init(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
            scrollView.setContentOffset(bottomOffset, animated: true)
            
        }else{ //Done Quiz
            //self.completedPractice()
            
        }
    }
    
    //Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_arrAnswers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_categoryquiz", for: indexPath) as! PracticeQuizTableViewCell
        let answer = m_arrAnswers.object(at: indexPath.row) as? String
        cell.lbl_answer.text = answer
        cell.lbl_status.text = statusString[indexPath.row]
        
        if(m_arrQuiz[c_QuizIndex].isTested){
            let answer = m_arrQuiz[c_QuizIndex].arrAnswers[indexPath.row] as! String
            let c_myAnswer = m_arrQuiz[c_QuizIndex].arrAnswers[m_arrQuiz[c_QuizIndex].selected_answer_index] as! String
            if(answer == c_myAnswer){
                if(c_myAnswer == c_CorrectAnswer){
                    cell.lbl_status_back.backgroundColor = colorAnswerCorrect
                }else{
                    cell.lbl_status_back.backgroundColor = colorAnswerWrong
                }
            }else if(c_CorrectAnswer == answer){
                cell.lbl_status_back.backgroundColor = colorAnswerCorrect
            }else{
                cell.lbl_status_back.backgroundColor = colorAnswerNormal
            }
        }else{
            if(c_CorrectAnswer == answer){
                cell.lbl_status_back.backgroundColor = colorAnswerCorrect
            }else{
                cell.lbl_status_back.backgroundColor = colorAnswerNormal
            }
        }


        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
