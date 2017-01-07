//
//  EditQuestionViewController.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 1/7/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit
import CoreData

class EditQuestionViewController: UIViewController, UITextFieldDelegate {
    
    var managedContext: NSManagedObjectContext!
    
    var questionImageView: UIImageView!
    var questionTextView: UITextView!
    var answerTextField: UITextField!
    
    var question: Question!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor(patternImage: UIImage(named: "snowyFloraBackground")!)
        edgesForExtendedLayout = []
        
        //assigning managed context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        questionImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.90, height: view.frame.width*0.675))
        questionImageView.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.25)
        
        questionTextView = UITextView(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.85, height: view.frame.width*0.5))
        questionTextView.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.25)
        questionTextView.textColor = .black
        questionTextView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        questionTextView.font = UIFont.boldSystemFont(ofSize: 20)
        
        answerTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.85, height: view.frame.width*0.125))
        answerTextField.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.65)
        answerTextField.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        answerTextField.layer.borderWidth = 0.25
        answerTextField.layer.cornerRadius = 8
        answerTextField.textColor = .black
        answerTextField.delegate = self
        answerTextField.addTarget(self, action: #selector(answerChanged), for: UIControlEvents.editingChanged)
        view.addSubview(answerTextField)
        
        loadQuestion()
        // Do any additional setup after loading the view.
    }
    
    func loadQuestion() {
        
        answerTextField.text = question.answer
        if question.hasImage {
            questionImageView.image = UIImage(data: (question.questionImage as! Data))
            view.addSubview(questionImageView)
        }
        else {
            questionTextView.text = question.questionText
            view.addSubview(questionTextView)
        }
    }
    
    func answerChanged() {
        if let newAnswer = answerTextField.text {
            if newAnswer.characters.count > 0 {
                question.answer = answerTextField.text
                do {
                    try managedContext.save()
                } catch {
                    print("Save error")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
