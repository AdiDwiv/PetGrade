//
//  PetDetailViewController.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 1/6/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit
import CoreData

class PetDetailViewController: UIViewController, UITextFieldDelegate {
    
    var pet: Pet!
    var managedContext: NSManagedObjectContext!
    var petNameTextField: UITextField!
    var detailLabel: UILabel!
    var detailTextView: UITextView!
    
    
    //Hardcoded Strings
    var headerPara: String = "KEEP YOUR PET ALIVE AND WELL!"
    var detailPara: String = "Regular retrieval of studied information has been proven to be better for long term recall than studying the information all over again. \nThe objective of petGrade is to let users create customized quizzes for topics of their choice. Questions can be taken from textbooks using the device's camera, from e-books using screenshots saved in your device's gallery and also through good old typing. \nUsers can then take these quizzes in a randomized order of questions anywhere and anytime. \n\nWhy should you quiz yourself regularly? \nIt improves your virtual pet's wellness! Wellness ranges from 0 to 100 and changes as per the following rules- \n>Your pet loses 5 wellness points everyday. \n>The longer the streak of consecutive days you quiz on is, the higher your pup's daily point boost will be, ranging from 1 point for 2 consecutive days up till 5 points for more 6 or more days. \n>You get 2 points for every right answer and lose 1 point for every wrong one. \n\nBe careful while entering answers for your questions. PetGrade is case-insensitive while checking answers but still requires the exact sequence of characters to be duplicated. \n\n Have fun quizzing!"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "snowyFloraBackground")!)
        edgesForExtendedLayout = []
        //assigning managed context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        let petNameLabel = UILabel(frame: CGRect(x: 0, y: view.frame.width*0.025, width: view.frame.width*0.35, height: 22))
        petNameLabel.font = UIFont.systemFont(ofSize: 20)
        petNameLabel.text = "Pet Name:"
        petNameLabel.minimumScaleFactor = 0.1
        petNameLabel.adjustsFontSizeToFitWidth = true
        
        petNameTextField = UITextField(frame: CGRect(x: view.frame.width*0.35, y: view.frame.width*0.025, width: view.frame.width*0.64, height: 22))
        petNameTextField.text = pet.name
        petNameTextField.font = UIFont.systemFont(ofSize: 20)
        //petNameTextField.borderStyle = .bezel
        petNameTextField.layer.borderWidth = 0.35
        petNameTextField.layer.borderColor = UIColor.black.cgColor
        petNameTextField.delegate = self
        petNameTextField.addTarget(self, action: #selector(nameChanged), for: UIControlEvents.editingChanged)
        
        detailLabel = UILabel(frame: CGRect(x: 0, y: view.frame.width*0.122, width: view.frame.width*0.85, height: view.frame.width*0.1))
        detailLabel.font = UIFont.boldSystemFont(ofSize: 18)
        detailLabel.minimumScaleFactor = 0.1
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.center.x = view.center.x
        detailLabel.textAlignment = .center
        detailLabel.text = headerPara
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: view.frame.width*0.105, width: view.frame.width*0.95, height: view.frame.height*0.8))
        detailTextView = UITextView(frame: scrollView.frame)
        detailTextView.font = UIFont.systemFont(ofSize: 15)
        detailTextView.text = detailPara
        scrollView.addSubview(detailTextView)
        
        view.addSubview(petNameLabel)
        view.addSubview(petNameTextField)
        view.addSubview(detailLabel)
        view.addSubview(scrollView)
    }
    func nameChanged() {
        pet.name = petNameTextField.text
        pet.save(managedContext: managedContext)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxCharacters = 8
        let fieldString: NSString = textField.text! as NSString
        let newString: NSString = fieldString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxCharacters
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
  
}
