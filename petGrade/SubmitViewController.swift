//
//  SubmitViewController.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 1/6/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit
import AVFoundation

class SubmitViewController: UIViewController {
    
    var quizState: QuizState!
    var pet: Pet!
    
    var correctImageView: UIImageView!
    var correctTextView: UITextView!
    var soundEffect: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = UIColor(patternImage: UIImage(named: "electricBlue2")!)
        
        correctImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.5, height: view.frame.width*0.5))
        correctImageView.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.25)
        correctImageView.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        correctTextView = UITextView(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.95, height: view.frame.width*0.65))
        correctTextView.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.65)
        correctTextView.textColor = .white
        correctTextView.backgroundColor = UIColor.white.withAlphaComponent(0)
        correctTextView.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        
        let successURL = URL(fileURLWithPath: Bundle.main.path(forResource: "success", ofType: "wav")!)
        let failureURL = URL(fileURLWithPath: Bundle.main.path(forResource: "failure", ofType: "wav")!)
        
        do {
            if quizState.isLastCorrect {
                correctImageView.image = UIImage(named: "correctIcon")
                let sound = try AVAudioPlayer(contentsOf: successURL)
                soundEffect = sound
            }
            else {
                correctImageView.image = UIImage(named: "wrongIcon")
                let sound = try AVAudioPlayer(contentsOf: failureURL)
                soundEffect = sound
            }
        } catch {
            print(error.localizedDescription)
        }
        soundEffect.play()
        let passedCount = quizState.questionsAsked - (quizState.correctCount+quizState.incorrectCount)
        correctTextView.text = "Correct Answer: "+quizState.correctAnswer+"\n"+pet.name!+"'s Wellness: "+String(pet.wellness)+"\n\nScore: \t\t"+String(quizState.correctCount)+" correct \n     \t\t\t"+String(quizState.incorrectCount)+" wrong  \n     \t\t\t"+String(passedCount)+" passed"
       
        view.addSubview(correctImageView)
        view.addSubview(correctTextView)
        
       navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next Question", style: .plain, target: self, action: #selector(nextButtonPressed))
      
    }
    
    func nextButtonPressed() {
        navigationController?.popViewController(animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
