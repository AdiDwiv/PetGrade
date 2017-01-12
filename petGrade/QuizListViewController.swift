//
//  QuizListViewController.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 12/29/16.
//  Copyright © 2016 org.adiproject. All rights reserved.
//

import UIKit
import CoreData

class QuizListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var managedContext: NSManagedObjectContext!
    
    var managedQuizList: [NSManagedObject]!
    var quizList: [Quiz] = []
    var quizTable: UITableView!
    var noQuizLabel: UILabel!
    var hasTable = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quizzes"
        view.backgroundColor = UIColor(patternImage: UIImage(named: "snowyFloraBackground")!)
    
        //assigning managed context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        //Setting up UI
        noQuizLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width*0.25))
        noQuizLabel.center = view.center
        noQuizLabel.text = "No quizzes added"
        noQuizLabel.textAlignment =  NSTextAlignment.center
        noQuizLabel.textColor = .darkGray
        noQuizLabel.font = UIFont.italicSystemFont(ofSize: 16.0)
        
        quizTable = UITableView(frame: view.frame)
        quizTable.dataSource = self
        quizTable.delegate = self
        quizTable.tableFooterView = UIView()
        quizTable.backgroundColor = UIColor.white.withAlphaComponent(0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Quiz", style: .plain, target: self, action: #selector(newButtonPressed))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //fetching quizzes
        fetchQuizData()
        reload()
    }
    
    func newButtonPressed() {
        let alert = UIAlertController(title: "New Quiz", message: "Enter quiz name", preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "Create", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            
            let textField = alert.textFields![0]
            if let quizName = textField.text {
                if quizName.characters.count != 0 {
                    
                    let newQuiz = self.save(quizName: quizName)
                    
                    self.quizList.append(newQuiz)
                    self.reload()
                    self.launchQuizViewController(quiz: newQuiz)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action:UIAlertAction) -> Void in })
        
        alert.addTextField { (textField) in textField.text = "" }
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /*Saving a new quiz (Core data save)
     */
    func save(quizName: String) -> Quiz {
        
        let quizEntity = NSEntityDescription.entity(forEntityName: "Quiz", in: managedContext)
        let newQuiz = NSManagedObject(entity: quizEntity!, insertInto: self.managedContext) as! Quiz
        newQuiz.quizName = quizName
        
        do {
            try managedContext.save()
        } catch {
            print("Save error")
        }
        return newQuiz
    }
    
    /*Fetches core data quizzes (Core data fetch)
     */
    func fetchQuizData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Quiz")
        do {
            managedQuizList = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            quizList = (managedQuizList as? [Quiz])!
        } catch {
            print("Fetch Error")
        }
    }
    
    /*Reloads table
     */
    func reload()  {
        quizTable.reloadData()
        if !hasTable && quizList.count != 0{
            noQuizLabel.removeFromSuperview()
            //view.reloadInputViews()
            view.addSubview(quizTable)
            hasTable = true
        }
        else if quizList.count == 0 {
            quizTable.removeFromSuperview()
            hasTable = false
            view.addSubview(noQuizLabel)
        }
    }
    
    /*Table view functions
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = QuizListTableViewCell(style: .default, reuseIdentifier: "Reuse")
        let quiz = quizList[indexPath.row]
        if let qSet = quiz.questions {
            cell.setup(name: quiz.quizName!, numberOfQuestions: qSet.count)
            return cell
        }
        cell.setup(name: quiz.quizName!, numberOfQuestions: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        launchQuizViewController(quiz: quizList[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedQuiz = managedQuizList[indexPath.row]
            managedContext.delete(managedQuiz)
            do {
                try managedContext.save()
            } catch {
                print("Save error")
            }
            quizList.remove(at: indexPath.row)
            reload()
        }
    }
    
    /* Launches question viewController
     */
    func launchQuizViewController(quiz: Quiz) {
        let quizViewController = QuizViewController()
        quizViewController.parentQuiz = quiz
        navigationController?.pushViewController(quizViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    
}
