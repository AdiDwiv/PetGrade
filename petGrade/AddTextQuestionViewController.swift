//
//  AddTextQuestionViewController.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 1/6/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit
import CoreData

class AddTextQuestionViewController: UIViewController, UITextFieldDelegate {
    
    var managedContext: NSManagedObjectContext!
    var parentQuiz: Quiz!
    
    var questionTextField: UITextField!
    var answerTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "snowyFloraBackground")!)
        //assigning managed context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        
        questionTextField = UITextField(frame: CGRect(x: 0, y: view.frame.width*0.25, width: view.frame.width*0.9, height: view.frame.height*0.35))
        questionTextField.center.x = view.center.x
        questionTextField.placeholder = "Enter question"
        //questionTextField.borderStyle = .roundedRect
        questionTextField.layer.borderWidth = 0.25
        questionTextField.layer.cornerRadius = 8
        questionTextField.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        questionTextField.font = UIFont.boldSystemFont(ofSize: 16)
        questionTextField.delegate = self
        
        answerTextField = UITextField(frame: CGRect(x: 0, y: view.frame.height*0.65, width: view.frame.width*0.9, height: view.frame.height*0.10))
        answerTextField.center.x = view.center.x
        answerTextField.placeholder = "Enter answer"
        //answerTextField.borderStyle = .roundedRect
        answerTextField.layer.borderWidth = 0.25
        answerTextField.layer.cornerRadius = 8
        answerTextField.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        answerTextField.font = UIFont.boldSystemFont(ofSize: 16)
        answerTextField.delegate = self
        
        let addButton = UIButton(frame: CGRect(x: 0, y: view.frame.height*0.825, width: view.frame.width*0.25, height: view.frame.width*0.125))
        addButton.setTitle("Add", for: .normal)
        addButton.backgroundColor = UIColor.green.withAlphaComponent(0.65)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        addButton.layer.cornerRadius = 12
        addButton.center.x = view.center.x*0.5
        addButton.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        addButton.setTitleColor(.white, for: .normal)
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: view.frame.height*0.825, width: view.frame.width*0.25, height: view.frame.width*0.125))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = UIColor.blue.withAlphaComponent(0.65)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        cancelButton.layer.cornerRadius = 12
        cancelButton.center.x = view.center.x*1.5
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        cancelButton.setTitleColor(.white, for: .normal)

        
        view.addSubview(questionTextField)
        view.addSubview(answerTextField)
        view.addSubview(addButton)
        view.addSubview(cancelButton)
        
    }
    
    func addPressed() {
       if (questionTextField.text?.characters.count)! > 0 && (answerTextField.text?.characters.count)! > 0 {
            let questionEntity = NSEntityDescription.entity(forEntityName: "Question", in: self.managedContext)
            let question = NSManagedObject(entity: questionEntity!, insertInto: self.managedContext) as! Question
            question.quiz = parentQuiz
            question.hasImage = false
            question.answer = answerTextField.text
            question.questionText = questionTextField.text
            do {
                try managedContext.save()
            } catch {
                print("Save error")
            }
            navigationController?.popViewController(animated: true)
        }
       else {
        let alert = UIAlertController(title: "Invalid input", message: "Please enter valid text", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            (action:UIAlertAction) -> Void in })
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    func cancelPressed() {
        navigationController?.popViewController(animated: true)
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
