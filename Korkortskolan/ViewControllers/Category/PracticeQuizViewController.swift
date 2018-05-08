//
//  PracticeQuizViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/15.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
import GTProgressBar
class PracticeQuizViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressview: UIView!
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var img_quiz: UIImageView!
    @IBOutlet weak var lbl_explanation: UILabel!
    @IBOutlet weak var lbl_question: UILabel!
    @IBOutlet weak var tbl_answers: UITableView!
    @IBOutlet weak var btn_nextquestion: UIButton!
    @IBOutlet weak var btn_nextarrow: UIButton!
    
    var tbl_cell_height = 60
    var category_id:String!
    var level:Int!
    var m_arrQuiz = [PFObject]()
    var m_arrAnswers:NSMutableArray!
    var c_QuizIndex = 0
    var c_CorrectAnswer:String!
    var c_myAnswer:String!
    var showResult  = false
    var countCorrectAnswered = 0
    var totalLevelAnswers = 0
    var totalClicked = 0
    var progressBar:GTProgressBar!
    let statusString = ["A","B","C","D","E","F","G"]
    override func viewDidLoad() {
        super.viewDidLoad()
        m_arrAnswers = NSMutableArray.init()
        // Do any additional setup after loading the view.
        getDBQuiz()
        progressBar = GTProgressBar(frame: CGRect.init(origin: CGPoint.zero, size: self.progressview.frame.size))
        self.progressview.addSubview(progressBar)
        showProgress(countDone: 0, total: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickNext(_ sender: Any) {
        c_QuizIndex = 0
        showResult = false
        m_arrAnswers = []
        showQuizInfo()
        let topOffset = CGPoint.init(x: 0, y: 0)
        scrollView.setContentOffset(topOffset, animated: true)
    }
    
    func emailUS(){
        let email = "test@test.com"
        if let url = URL(string: "mailto:\(email)"){
            UIApplication.shared.open(url)
        }
    }
    func getDBQuiz(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = PFQuery(className: "Quiz_Detail")
        query.whereKey("category_id", equalTo: category_id)
        query.whereKey("level", equalTo: String(level))
        query.order(byAscending: "order")
        query.findObjectsInBackground(block: { (quizs : [PFObject]?, error: Error!) -> Void in
            if error == nil {
                self.m_arrQuiz = quizs!
                self.totalLevelAnswers = self.m_arrQuiz.count
                DispatchQueue.main.async {
                    self.showQuizInfo()
                }
            }else{
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func showQuizInfo(){
        if(m_arrQuiz.count == 0){
                completedPractice()
        }
        else if(0 < m_arrQuiz.count){
            
            //show Quiz
            let quiz = m_arrQuiz[c_QuizIndex]
            showProgress(countDone: countCorrectAnswered, total: totalLevelAnswers)
            lbl_question.text = quiz["question"] as? String
            lbl_explanation.text = quiz["explanation"] as? String
            if let image = quiz.value(forKey: "image") as? PFFile {
                image.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        DispatchQueue.main.async {
                            self.img_quiz.image = image
                        }
                    }
                })
            }
            
            let correct_answer = quiz["correct_answer"] as? String
            c_CorrectAnswer = correct_answer
            c_myAnswer = ""
            let wrong_answer_1 = quiz["wrong_answer_1"] as? String
            let wrong_answer_2 = quiz["wrong_answer_2"] as? String
            let wrong_answer_3 = quiz["wrong_answer_3"] as? String
            let wrong_answer_4 = quiz["wrong_answer_4"] as? String
            let wrong_answer_5 = quiz["wrong_answer_5"] as? String
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
            m_arrAnswers = NSMutableArray.init(array: m_arrAnswers.shuffled())
            btn_nextquestion.isHidden = true
            lbl_explanation.isHidden = true
            btn_nextarrow.isHidden = true
            self.tbl_answers.reloadData()
            
        }else{ //Done Quiz
            self.completedPractice()
        }
        
        lbl_explanation.sizeToFit()
        let tbl_height = m_arrAnswers.count * tbl_cell_height + 2
        tbl_answers.frame = CGRect.init(origin: tbl_answers.frame.origin, size: CGSize.init(width: Int(tbl_answers.frame.size.width), height: tbl_height))
        lbl_explanation.frame = CGRect.init(x: lbl_explanation.frame.origin.x, y: tbl_answers.frame.origin.y + CGFloat(tbl_height) + 10, width: lbl_explanation.frame.width, height: lbl_explanation.frame.height)
        view_content.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: view_content.frame.width, height: lbl_explanation.frame.origin.y + lbl_explanation.frame.size.height + btn_nextquestion.frame.height+20) )
        
        scrollView.contentSize = view_content.frame.size
        scrollView.addSubview(view_content)
        scrollView.isScrollEnabled = true
    }
    
    func showProgress(countDone:Int, total:Int){
        
        progressBar.progress = CGFloat(Float(countDone) / Float(total))
        progressBar.barFillColor = UIColor.init(rgb: 0xffcf00)
        progressBar.barBackgroundColor = UIColor.init(rgb:0x4e4a4c)
        progressBar.barBorderWidth = 0
        progressBar.barFillInset = 0
        progressBar.displayLabel = false
        progressBar.progressLabelInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        progressBar.barMaxHeight = 15
    }
    
    func completedPractice(){
        saveResult()
        if(UserDefaults.standard.integer(forKey: "done_levels_categoryid_" + category_id) < level)
        {
            UserDefaults.standard.set(level, forKey: "done_levels_categoryid_" + category_id)
        }
        self.navigationController?.popViewController(animated: true)
    }
    func saveResult(){
        UserDefaults.standard.set(countCorrectAnswered, forKey: "correct_"+category_id+"_level_"+String(level))
        UserDefaults.standard.set(m_arrQuiz.count, forKey: "total_"+category_id+"_level_"+String(level))
        UserDefaults.standard.set(totalClicked, forKey: "testclicked_"+category_id+"_level_"+String(level))
    }
    
    //Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_arrAnswers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_practicequiz", for: indexPath) as! PracticeQuizTableViewCell
        let answer = m_arrAnswers.object(at: indexPath.row) as? String
        cell.lbl_answer.text = answer
        cell.lbl_status.text = statusString[indexPath.row]
        if(showResult){
            if(c_myAnswer == answer){
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
            cell.lbl_status_back.backgroundColor = colorAnswerNormal
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!showResult){
            showResult = true
            totalClicked += 1
            c_myAnswer = m_arrAnswers.object(at: indexPath.row) as? String
            if(c_myAnswer == c_CorrectAnswer){
                countCorrectAnswered += 1
                saveResult()
                m_arrQuiz.remove(at: c_QuizIndex)
                showProgress(countDone: countCorrectAnswered, total: totalLevelAnswers)
                if(countCorrectAnswered == totalLevelAnswers){
                    btn_nextquestion.setTitle("Done Practice", for: .normal)
                }
            }else{
                let cDic = m_arrQuiz[c_QuizIndex]
                m_arrQuiz.remove(at: c_QuizIndex)
                m_arrQuiz.append(cDic)
            }
            tbl_answers.reloadData()
            showHiddens()
        }
    }
    
    func showHiddens(){
        btn_nextquestion.isHidden = false
        btn_nextarrow.isHidden = false
        lbl_explanation.isHidden = false
        if(scrollView.contentSize.height>self.view.frame.size.height){
            let bottomOffset = CGPoint.init(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
}
