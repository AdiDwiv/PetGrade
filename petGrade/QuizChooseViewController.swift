//
//  QuizChooseViewController.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 1/5/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit
import CoreData

class QuizChooseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var managedContext: NSManagedObjectContext!
    
    var quizList: [Quiz] = []
    var pet: Pet!
    
    var quizTable: UITableView!
    var noQuizLabel: UILabel!
    var hasTable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose a Quiz"
        view.backgroundColor = UIColor(patternImage: UIImage(named: "snowyFloraBackground")!)
        
        //assigning managed context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        //fetching quizzes
        fetchQuizData()
        
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
        
        if quizList.count != 0 {
            view.addSubview(quizTable)
            hasTable = true
        }
        else {
            view.addSubview(noQuizLabel)
        }
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*Fetches core data quizzes (Core data fetch)
     */
    func fetchQuizData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Quiz")
        do {
            quizList = try managedContext.fetch(fetchRequest) as! [Quiz]
        } catch {
            print("Fetch Error")
        }
    }
    
    //Table View functions
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
        quizTable.deselectRow(at: indexPath, animated: true)
        let quizzerController = QuizzerViewController()
        quizzerController.quiz = quizList[indexPath.row]
        quizzerController.pet = pet
        navigationController?.pushViewController(quizzerController, animated: true)
    }

}
