//
//  QuizzerViewController.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 1/5/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit
import CoreData

class QuizState {
    var questionsAsked: Int = 0
    var correctCount: Int = 0
    var incorrectCount: Int = 0
    var isLastCorrect: Bool = false
    var correctAnswer: String!
}


class QuizzerViewController: UIViewController, UITextFieldDelegate {
    
    var quiz: Quiz!
    var questionList: [Question] = []
    var question: Question!
    var pet: Pet!
    var quizState: QuizState!
    var managedContext: NSManagedObjectContext!
    
    var questionImageView: UIImageView!
    var questionTextView: UITextView!
    var answerTextField: UITextField!
    var submitButton: UIButton!
    var passButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = quiz.quizName
        view.backgroundColor = UIColor(patternImage: UIImage(named: "blackBulletBackground")!)
        edgesForExtendedLayout = []
        //assigning managed context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
       
        getQuestions()
        quizState = QuizState()
        calculateWellness()
        
        questionImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.90, height: view.frame.width*0.675))
        questionImageView.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.25)
        
        questionTextView = UITextView(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.85, height: view.frame.width*0.5))
        questionTextView.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.25)
        questionTextView.textColor = .white
        questionTextView.backgroundColor = UIColor.white.withAlphaComponent(0)
        questionTextView.font = UIFont.boldSystemFont(ofSize: 20)
        
        answerTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.85, height: view.frame.width*0.125))
        answerTextField.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.65)
        answerTextField.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        answerTextField.textColor = .white
        answerTextField.delegate = self
        
        submitButton = UIButton(frame: CGRect(x: 0, y: view.frame.height*0.75, width: view.frame.width*0.25, height: view.frame.width*0.125))
        submitButton.center.x = view.center.x*0.5
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = UIColor.green.withAlphaComponent(0.75)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        submitButton.layer.cornerRadius = 10
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        
        passButton = UIButton(frame: CGRect(x: 0, y: view.frame.height*0.75, width: view.frame.width*0.25, height: view.frame.width*0.125))
        passButton.center.x = view.center.x*1.5
        passButton.setTitle("Pass", for: .normal)
        passButton.setTitleColor(.white, for: .normal)
        passButton.backgroundColor = UIColor.cyan.withAlphaComponent(0.75)
        passButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        passButton.layer.cornerRadius = 10
        passButton.addTarget(self, action: #selector(pass), for: .touchUpInside)
        
        
        view.addSubview(answerTextField)
        view.addSubview(submitButton)
        view.addSubview(passButton)
        
        //loadQuestion()
        
    }
    
    /* Stores quiz questions in list
     */
    func getQuestions() {
        if let questions = quiz.questions {
            for question in questions {
                questionList.append(question as! Question)
            }
        }
    }
    /* Loads individual questions
     */
    func loadQuestion() {
        answerTextField.text = ""
        questionImageView.removeFromSuperview()
        questionTextView.removeFromSuperview()
        
        let n = Int(arc4random_uniform(UInt32(questionList.count)))
        question = questionList[n]
        questionList.remove(at: n)
        quizState.correctAnswer = question.answer!
        if question.hasImage {
            questionImageView.image = UIImage(data: (question.questionImage as! Data))
            view.addSubview(questionImageView)
        }
        else {
            questionTextView.text = question.questionText
            view.addSubview(questionTextView)
        }
    }
    
    /* Action button for submit
     */
    func submitButtonPressed()  {
        if let answerText = answerTextField.text {
             quizState.questionsAsked += 1
            if(answerText.caseInsensitiveCompare(question.answer!) == .orderedSame) {
                quizState.correctCount += 1
                pet.changeWellness(change: 2)
                pet.save(managedContext: managedContext)
                quizState.isLastCorrect = true
            }
            else {
                quizState.incorrectCount += 1
                pet.changeWellness(change: -1)
                pet.save(managedContext: managedContext)
                quizState.isLastCorrect = false
            }
            submit()
        }
    }
    /* Submits answer
     */
    func submit() {
        let submitViewController = SubmitViewController()
        submitViewController.quizState = quizState
        submitViewController.pet = pet
        navigationController?.pushViewController(submitViewController, animated: false)
    }
    
    /* Passes question
     */
    func pass() {
        quizState.questionsAsked += 1
        if questionList.count == 0 {
            noQuestionsLeft()
        }
        else {
            loadQuestion()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if questionList.count == 0 {
           noQuestionsLeft()
        }
        else {
            loadQuestion()
        }
    }
    
    /*Navigates away if no questions left*/
    func noQuestionsLeft() {
        let alert = UIAlertController(title: "Finished", message: "There are no more questions remaining in this quiz", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /* Checks for day streaks and improves wellness
     */
    func calculateWellness() {
        print("here")
        let dateOpen  = pet.dateLastOpened
        
        let difference = pet.dayDifference(start: dateOpen!, end: Date())
        let streakLength: Int = pet.dayDifference(start: pet.dateStreak as! Date, end: Date())
        var pointBoost: Int = 0
        if difference == 1 {
            print("here2")
            if streakLength < 5 {
                pet.changeWellness(change: streakLength)
                pointBoost = streakLength
            } else {
                pet.changeWellness(change: 5)
                pointBoost = 5
            }
            let alert = UIAlertController(title: "Streak", message: "Your current streak  "+String(streakLength)+" days \nPoint boost: "+String(pointBoost), preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: {
                (action:UIAlertAction) -> Void in})
            alert.addAction(okayAction)
            self.present(alert, animated: true, completion: nil)
        } else if difference != 0 {
            pet.dateStreak = Date() as NSDate
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
