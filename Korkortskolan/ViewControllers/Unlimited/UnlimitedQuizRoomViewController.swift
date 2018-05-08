//
//  CategoryQuizViewController.swift
//  Korkortskolan
//
//  Created by Zhou on 2017/11/16.
//  Copyright © 2017 Famousming. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

class UnlimitedQuizRoomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_quiz: UIImageView!
    @IBOutlet weak var lbl_question: UILabel!
    @IBOutlet weak var tbl_answers: UITableView!
    @IBOutlet weak var btn_nextquestion: UIButton!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var btn_pause: UIButton!
    @IBOutlet weak var btn_previous: UIButton!
    @IBOutlet weak var btn_finish: UIButton!
    

    @IBOutlet weak var notification_unanswered: UIView!
    @IBOutlet weak var notification_pause: UIView!
    @IBOutlet weak var notification_Timeout: UIView!
    @IBOutlet weak var view_notification: UIView!
    @IBOutlet weak var lbl_resulttitle: UILabel!
    @IBOutlet weak var lbl_unanswered: UILabel!
    
    var unlimited_title:String!
    var unlimited_id:String!
    var unlimited_type:String!
    
    var m_arrQuiz = [Quiz]()
    var durations = [Int]()
    var m_arrAnswers:NSMutableArray!
    var m_arrQuizForSave:NSMutableArray!
    
    var c_QuizIndex = 0
    var c_CorrectAnswer:String!
    var c_myAnswer:String!
    var m_arrMyAnswers:NSMutableArray!
    
    var quizTimer : Timer!
    var timerPaused = false
    var countTimer = 0
    let statusString = ["A","B","C","D","E","F","G"]
    
    let stampformatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        m_arrAnswers = NSMutableArray.init()
        m_arrMyAnswers = NSMutableArray.init()
        m_arrQuizForSave = NSMutableArray.init()
        
        notification_pause.isHidden = true
        notification_unanswered.isHidden = true
        notification_Timeout.isHidden = true
        
        getDBQuiz()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickPause(_ sender: Any) {
        timerPaused = !timerPaused
        stopTimer()
        notification_pause.isHidden = false
//        if(timerPaused){
//            btn_nextquestion.isEnabled = false
//            tbl_answers.isUserInteractionEnabled = false
//            btn_pause.setImage(UIImage.init(named: "btn_play"), for: .normal)
//            stopTimer()
//        }else{
//            btn_nextquestion.isEnabled = true
//            tbl_answers.isUserInteractionEnabled = true
//            btn_pause.setImage(UIImage.init(named: "btn_pause"), for: .normal)
//            startTimer()
//        }
    }
    @IBAction func clickYesPause(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickNoBack(_ sender: Any) {
        notification_pause.isHidden = true
        if(countTimer > 0)
        {
            startTimer()
        }
    }
    
    @IBAction func clickBack(_ sender: Any) {
        let alert = UIAlertController(title: "Korkortskolan", message: "Are you sure to leave this quiz?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func clickNext(_ sender: Any) {
        c_QuizIndex = c_QuizIndex + 1
        btn_previous.isEnabled = true
        if(m_arrQuiz[c_QuizIndex].isTested){
            lbl_time.text = String(m_arrQuiz[c_QuizIndex].duration)
        }else{
//            countTimer = perQuizSeconds
//            startTimer()
        }
        m_arrAnswers = []
        showQuizInfo()

    }
    
    @IBAction func clickPrevious(_ sender: Any) {
        c_QuizIndex -= 1
        if c_QuizIndex == 0{
            btn_previous.isEnabled = false
        }else{
            btn_previous.isEnabled = true
        }
        if(m_arrQuiz[c_QuizIndex].isTested){
            lbl_time.text = String(m_arrQuiz[c_QuizIndex].duration)
        }else{
//            countTimer = perQuizSeconds
//            startTimer()
        }
        m_arrAnswers = []
        showQuizInfo()
    }
    
    func checkBtnStatus(){
        if c_QuizIndex == 0{
            btn_previous.isEnabled = false
        }
        if(m_arrQuiz.count == 1 || m_arrQuiz.count == c_QuizIndex-1){
            btn_nextquestion.isEnabled = false
        }
    }
    @IBAction func clickLeaveQuiz(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickFinish(_ sender: Any) {
        var answeredCount = 0
        for quiz in m_arrQuiz {
            if(quiz.isTested){
                answeredCount += 1
            }
        }
        if(answeredCount < m_arrQuiz.count){
            notification_unanswered.isHidden = false
            let unCount = String(m_arrQuiz.count - answeredCount)
            lbl_unanswered.text = "You have \(unCount) unanswered questions."
        }else{
            completedPractice()
        }
    }
    
    @IBAction func timeOutClose(_ sender: Any) {
        //completedPractice()
        notification_Timeout.isHidden = true
    }
    @IBAction func timeOutContinue(_ sender: Any) {
        //completedPractice()
        notification_Timeout.isHidden = true
    }
    
    @IBAction func clickUnanswerClose(_ sender: Any) {
        notification_unanswered.isHidden = true
    }
    
    @IBAction func clickGoThroughTest(_ sender: Any) {
        notification_unanswered.isHidden = true
    }
    
    @IBAction func clickFinishTest(_ sender: Any) {
        completedPractice()
    }
    
    @objc func countQuizTimer(){
        countTimer = countTimer - 1
        if(countTimer < 0){
            countTimer = 0
            stopTimer()
            notification_Timeout.isHidden = false
        }else{
            let sec = countTimer % 60
            let min = countTimer / 60
            var str = ""
            if(min == 1){
                str = "1 MIN "
            }else if(min > 1){
                str = String(min) + " MIN "
            }else{
                if(sec <= 1){
                    str = str + String(sec) + " SEC"
                }else {
                    str = str + String(sec) + " SEC"
                }
            }
            lbl_time.text = str
        }
    }
    func startTimer(){
        stopTimer()
        quizTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.countQuizTimer), userInfo: nil, repeats: true)
    }
    func stopTimer(){
        if(quizTimer != nil){
            quizTimer.invalidate()
            quizTimer = nil
        }
    }
    func emailUS(){
        let email = "test@test.com"
        if let url = URL(string: "mailto:\(email)"){
            UIApplication.shared.open(url)
        }
    }
    func getDBQuiz(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = PFQuery(className: "Unlimited_Quiz_Detail")
        if(unlimited_type == "quiz"){
            query.whereKey("unlimited_quiz_id", equalTo: unlimited_id)
        }else{
        }
        query.findObjectsInBackground(block: { (quizs : [PFObject]?, error: Error!) -> Void in
            if error == nil {

                for quiz in quizs!{
                    let mQuiz = Quiz.init(withPFObj: quiz)
                    self.m_arrQuiz.append(mQuiz)
                }
                if(self.m_arrQuiz.count == 0){
                    Helper.showAlert(target: self, title:"Warning!" , message: "Please wait. Unlimited Quizes were not uploaded.",completion:{
                        self.navigationController?.popViewController(animated: true)
                    })
                }else{
                    self.m_arrQuiz = NSMutableArray.init(array: self.m_arrQuiz.shuffled()) as! [Quiz]
                    if(self.unlimited_type == "quiz"){
                        if self.m_arrQuiz.count > 20{
                            self.m_arrQuiz = [Quiz](self.m_arrQuiz.prefix(20))
                        }
                    }else{
                        
                        let limit = Int(self.unlimited_type)!
                        if self.m_arrQuiz.count > limit {
                            self.m_arrQuiz = [Quiz](self.m_arrQuiz.prefix(limit))
                        }
                    }
                    DispatchQueue.main.async {
                        self.countTimer = perQuizSeconds * self.m_arrQuiz.count
                        self.checkBtnStatus()
                        self.showQuizInfo()
                        self.startTimer()
                    }
                }
            }else{
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func showQuizInfo(){
        if(m_arrQuiz.count == 0){
            Helper.showAlert(target: self, title:"Warning!" , message: "Please wait. This Category Quiz is not uploaded.", completion:{
                self.navigationController?.popViewController(animated: true)
            })
        }
        else if(c_QuizIndex + 1 <= m_arrQuiz.count){
            if(c_QuizIndex == m_arrQuiz.count - 1){
                btn_nextquestion.isHidden = true
                btn_finish.isHidden = false
            }else{
                btn_nextquestion.isHidden = false
                btn_finish.isHidden = true
            }
            //show Quiz
            let quiz = m_arrQuiz[c_QuizIndex]
            lbl_title.text = String(c_QuizIndex+1) + " / " + String(m_arrQuiz.count)
            lbl_question.text = quiz.question
            self.img_quiz.image = UIImage.init(data: quiz.image)
            c_CorrectAnswer = quiz.correct_answer
            c_myAnswer = ""
            m_arrAnswers = quiz.arrAnswers
            self.tbl_answers.reloadData()
            
        }else{ //Done Quiz
            //self.completedPractice()
        }
    }
    
    func completedPractice(){
        stopTimer()
//        lbl_resulttitle.text = "YOU PASSED"
//        lbl_resultCount.text = "RESULT: " + String(c_QuizIndex) + "/" + String(m_arrQuiz.count)
//        let min = countTimer / 60
//        let sec = countTimer % 60
//        lbl_resultTime.text = "TIME: " + twoCharacters(val: min) + ":" + twoCharacters(val: sec)
        saveQuizResult()
        let resultView = self.storyboard?.instantiateViewController(withIdentifier: "SB_RESULT") as! QuizResultViewController
        resultView.category_id = unlimited_id
        resultView.isUnlimited = true
        self.navigationController?.pushViewController(resultView, animated: true)
    }
    
    func twoCharacters(val:Int)->String{
        if(val < 10){
            return "0" + String(val)
        }else{
            return String(val)
        }
    }
    func saveQuizResult(){
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: m_arrQuiz)
        UserDefaults.standard.setValue(archivedData, forKey: "unlimited_quiz_res_" + unlimited_id)
        saveHistory()
    }
    
    func saveHistory(){
        var history_count = UserDefaults.standard.integer(forKey: "history_count")
        history_count += 1
        var total_duration = 0
        var correctedCount = 0
        for quiz in m_arrQuiz{
            total_duration += quiz.duration
            let cAnswer = quiz.correct_answer as String
            let myAnswer =  quiz.arrAnswers[quiz.selected_answer_index] as! String
            if(cAnswer == myAnswer){
                correctedCount += 1
            }
        }
        let min = total_duration / 60
        let sec = total_duration % 60
        let strDuration =  twoCharacters(val: min) + ":" + twoCharacters(val: sec)
        let history_title = unlimited_title + " Final"
        let time = stampformatter.string(from: Date())
        let history = ["title":history_title,"time":time,"duration":strDuration,"correct_count":String(correctedCount),"total_count":String(m_arrQuiz.count)]
        UserDefaults.standard.set(history, forKey: "history_"+String(history_count))
        UserDefaults.standard.set(history_count, forKey: "history_count")
    }
    
    func saveMyAnswer(index:Int , duration:Int){
        // Save Quiz for NSUSERDEFAULTS
        m_arrQuiz[c_QuizIndex].isTested = true
        m_arrQuiz[c_QuizIndex].selected_answer_index = index
        m_arrQuiz[c_QuizIndex].duration = duration
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
            if(m_arrQuiz[c_QuizIndex].selected_answer_index == indexPath.row){
                cell.lbl_status_back.backgroundColor = UIColor.init(rgb: 0xffcf03)
            }else{
                cell.lbl_status_back.backgroundColor = colorAnswerNormal
            }
        }else{
            cell.lbl_status_back.backgroundColor = colorAnswerNormal
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!m_arrQuiz[c_QuizIndex].isTested){
            c_myAnswer = m_arrAnswers.object(at: indexPath.row) as? String
            saveMyAnswer(index: indexPath.row, duration:perQuizSeconds*self.m_arrQuiz.count - countTimer)
            tbl_answers.reloadData()
        }
    }
    
}
