//
//  QuizViewController.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 1/1/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit
import CoreData

class QuizViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var managedContext: NSManagedObjectContext!
    
    var parentQuiz: Quiz!
    var managedQuestionList: [NSManagedObject] = []
    var questionList: [Question] = []
    
    var questionTable: UITableView!
    
    
    var scrollView: UIScrollView!
    var removeMenuGesture: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = parentQuiz.quizName
        view.backgroundColor = UIColor(patternImage: UIImage(named: "snowyFloraBackground")!)
        
        //assigning managed context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        //setting up ui
        questionTable = UITableView(frame: view.frame)
        questionTable.backgroundColor = .white
        questionTable.tableFooterView = UIView()
        questionTable.rowHeight = view.frame.height*0.25
        
        questionTable.dataSource = self
        questionTable.delegate = self
        questionTable.backgroundColor = UIColor.white.withAlphaComponent(0)
        view.addSubview(questionTable)
       
        scrollView = UIScrollView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New question", style: .plain, target: self, action: #selector(addQuestionTapped))
        
        removeMenuGesture = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        removeMenuGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(removeMenuGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Getting Questions
        questionList.removeAll()
        managedQuestionList.removeAll()
        setUpList()
        questionTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /* Closes dropdown menu
     */
    func closeMenu() {
        if scrollView.isDescendant(of: view) {
            scrollView.removeFromSuperview()
        }
        removeMenuGesture.cancelsTouchesInView = false
    }
    
    /*Opens dropdown menu
     */
    func addQuestionTapped() {
        let ypos = (navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        scrollView.frame = CGRect(x: view.frame.width*0.5, y: ypos, width: view.frame.width*0.5, height: view.frame.height*0.25 )
        scrollView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.85)
        
        let buttonHeight = scrollView.frame.height/3
        let buttonCamera = UIButton(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: buttonHeight))
        buttonCamera.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        buttonCamera.setTitle("Take photo", for: .normal)
        let buttonPhotos = UIButton(frame: CGRect(x: 0, y: buttonHeight, width: scrollView.frame.width, height: buttonHeight))
        buttonPhotos.setTitle("Gallery", for: .normal)
        buttonPhotos.addTarget(self, action: #selector(photosButtonPressed), for: .touchUpInside)
        let buttonText = UIButton(frame: CGRect(x: 0, y: buttonHeight*2, width: scrollView.frame.width, height: buttonHeight))
        buttonText.setTitle("Enter text", for: .normal)
        buttonText.addTarget(self, action: #selector(textButtonPressed), for: .touchUpInside)
        
        scrollView.addSubview(buttonCamera)
        scrollView.addSubview(buttonPhotos)
        scrollView.addSubview(buttonText)
        
        removeMenuGesture.cancelsTouchesInView = true
        view.addSubview(scrollView)
    }
    
    /*Dropdown menu buttons
    */
    func cameraButtonPressed() {
        closeMenu()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            print("Entered here")
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.allowsEditing = false
            
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func photosButtonPressed() {
        closeMenu()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func textButtonPressed() {
        closeMenu()
        saveWithText()
    }
    
    /* Image picker delegate - executed after image is picked
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            displayAlert(image: image)
        }
        else {
            print("Error")
        }
        
        questionTable.reloadData()
    }
    
    /* Diplays prompt alert for answer
     */
    func displayAlert(image: UIImage!) {
        
        let alert = UIAlertController(title: "Answer", message: "Enter a 1-5 word easy to remember answer to the given problem. \n (Empty answers not accepted)", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            
            let textField = alert.textFields![0]
            if let ans = textField.text {
                if ans.characters.count != 0 {
                    self.saveWithImage(answer: ans, image: image)
                    self.questionTable.reloadData()
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action:UIAlertAction) -> Void in })
        
        alert.addTextField { (textField) in textField.text = "" }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
     }
    
    /* Saves question with image
     */
    func saveWithImage(answer: String, image: UIImage) {
        
        let questionEntity = NSEntityDescription.entity(forEntityName: "Question", in: self.managedContext)
        let newQuestion = NSManagedObject(entity: questionEntity!, insertInto: self.managedContext) as! Question
        newQuestion.quiz = parentQuiz
        newQuestion.answer = answer
        newQuestion.hasImage = true
        newQuestion.questionImage = NSData(data: UIImagePNGRepresentation(image)!)
        
        questionList.append(newQuestion)
        
        do {
            try managedContext.save()
        } catch {
            print("Save error")
        }
    }
    
    /* Saves question with text
     */
    func saveWithText() {
        let textQuestionViewController = AddTextQuestionViewController()
        textQuestionViewController.parentQuiz = parentQuiz
        navigationController?.pushViewController(textQuestionViewController, animated: true)
    }
    
    /* Sets up list of questions
     */
    func setUpList() {
        if let questionSet = parentQuiz.questions {
            for question in questionSet {
                managedQuestionList.append(question as! NSManagedObject)
                questionList.append(question as! Question)
            }
        }
    }
  
    
    /*Table view delegate and data source
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let question = questionList[indexPath.row]
        var imageForQuestion : UIImage? = nil
        if question.hasImage {
            imageForQuestion = UIImage(data: (question.questionImage as! Data))
        }
        
        if let cell = questionTable.dequeueReusableCell(withIdentifier: "reuse") as? QuizTableViewCell {
            print("Being executed")
            cell.setup(label: question.answer!, image: imageForQuestion)
            return cell
        }
        let cell = QuizTableViewCell(style: .default, reuseIdentifier: "Reuse")
        cell.setup(label: question.answer!, image: imageForQuestion)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editQuesController = EditQuestionViewController()
        print("here")
        editQuesController.question = questionList[indexPath.row]
        print(editQuesController.question.answer!)
        navigationController?.pushViewController(editQuesController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedQuestion = managedQuestionList[indexPath.row]
            managedContext.delete(managedQuestion)
            do {
                try managedContext.save()
            } catch {
                print("Save error")
            }
            questionList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
