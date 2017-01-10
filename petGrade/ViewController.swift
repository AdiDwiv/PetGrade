//
//  ViewController.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 12/29/16.
//  Copyright © 2016 org.adiproject. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    var petImageView: UIImageView!
    var managedContext: NSManagedObjectContext!
    var wellnessLabel: UILabel!
    
    var pet: Pet!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PetGrade"
        view.backgroundColor = UIColor(patternImage: UIImage(named: "snowyFloraBackground")!)
        edgesForExtendedLayout = []
        //assigning managed context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        petImageView = UIImageView(frame: CGRect(x: 0, y: view.frame.width*0.025, width: view.frame.width*0.75, height: view.frame.height*0.45))
        petImageView.center.x = view.center.x
        petImageView.image = UIImage(named: "placeholder")
        petImageView.clipsToBounds = true
        petImageView.layer.cornerRadius = 3
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        petImageView.addGestureRecognizer(gestureRecog)
        petImageView.isUserInteractionEnabled = true
        
        view.addSubview(petImageView)
        
        wellnessLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height*0.50, width: view.frame.width*0.85, height: view.frame.width*0.25))
        wellnessLabel.textColor = .black
        wellnessLabel.center.x = view.center.x
        wellnessLabel.font = UIFont(name: "Chalkduster", size:24)
        wellnessLabel.textAlignment = .center
        wellnessLabel.minimumScaleFactor = 0.1
        wellnessLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(wellnessLabel)
        
        let quizButton = UIButton(frame: CGRect(x: 0, y: view.frame.height*0.725, width: view.frame.width*0.35, height: view.frame.width*0.125))
        quizButton.center.x = view.center.x*0.5
        quizButton.setTitle("<< Quiz yourself", for: .normal)
        quizButton.setTitleColor(.white, for: .normal)
        quizButton.backgroundColor = UIColor.green.withAlphaComponent(0.65)
        quizButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        quizButton.layer.cornerRadius = 12
        quizButton.addTarget(self, action: #selector(quizButtonPressed), for: .touchUpInside)
        let swipeQuiz = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedResponse) )
        swipeQuiz.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeQuiz)
        view.addSubview(quizButton)
        
        
        let editButton = UIButton(frame: CGRect(x: 0, y: view.frame.height*0.725, width: view.frame.width*0.35, height: view.frame.width*0.125))
        editButton.center.x = view.center.x*1.5
        editButton.setTitle("Edit quizzes >>", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.backgroundColor = UIColor.blue.withAlphaComponent(0.65)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        editButton.layer.cornerRadius = 12
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        let swipeEdit = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedResponse))
        swipeEdit.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(swipeEdit)
        view.addSubview(editButton)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        let petArr = fetchPetData()
        if petArr.count == 1 {
            pet = petArr[0] 
            calculateWellness()
        }
        else {
            let petEntity = NSEntityDescription.entity(forEntityName: "Pet", in: managedContext)
            pet = NSManagedObject(entity: petEntity!, insertInto: managedContext) as! Pet
            pet.name = "Hector"
            pet.wellness = 60
            pet.dateOpened = Date() as NSDate
            pet.dateStreak = Date() as NSDate
            
            pet.save(managedContext: managedContext)
        }
        
        if pet.wellness == 100 {
            petImageView.image = UIImage(named: "happySuperMaxCropped")
        } else if pet.wellness >= 90 {
            petImageView.image = UIImage(named: "happySuperCropped")
        } else if pet.wellness >= 75 {
            petImageView.image = UIImage(named: "happyMidAboveAverageCropped")
        } else if pet.wellness >= 58 {
            petImageView.image = UIImage(named: "happyMidCropped")
        } else if pet.wellness >= 50 {
            print("Check")
            petImageView.image = UIImage(named: "happyMidPerturbedCropped")
        } else if pet.wellness >= 25 {
            print("Check")
            petImageView.image = UIImage(named: "distressedMidCropped.png")
        } else if pet.wellness > 0 {
            petImageView.image = UIImage(named: "distressedSuperCropped")
        } else  {
            petImageView.image = UIImage(named: "deadCropped")
        }
        
        wellnessLabel.text = pet.name!+"'s wellness: "+String(pet.wellness)+"%"
    }
    
    func calculateWellness() {
        pet.dateLastOpened = pet.dateOpened as! Date
        pet.dateOpened = Date() as NSDate
        let difference = pet.dayDifference(start: pet.dateLastOpened, end: Date())
        pet.changeWellness(change: -5*difference)
        pet.save(managedContext: managedContext)
    }
    
    func swipedResponse(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if swipeGesture.direction == .right {
                quizButtonPressed()
            } else {
                editButtonPressed()
            }
        }
    }
    
    
    func fetchPetData() -> [Pet] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pet")
        do {
            let petArray = try managedContext.fetch(fetchRequest) as! [Pet]
            return petArray
        } catch {
            print("fetch error")
        }
        return []
    }
    
    func editButtonPressed() {
        navigationController?.pushViewController(QuizListViewController(), animated: true)
    }
    
    func quizButtonPressed() {
        let quizChooseViewController = QuizChooseViewController()
        quizChooseViewController.pet = pet
        navigationController?.pushViewController(quizChooseViewController, animated: false)
    }
    
    func imageTapped() {
        let petDetailViewController = PetDetailViewController()
        petDetailViewController.pet = pet
        navigationController?.pushViewController(petDetailViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

