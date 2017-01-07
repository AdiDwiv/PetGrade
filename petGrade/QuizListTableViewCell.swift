//
//  QuizListTableViewCell.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 1/5/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit

class QuizListTableViewCell: UITableViewCell {

    var nameLabel: UILabel!
    var numberLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white.withAlphaComponent(0.25)
        
        nameLabel = UILabel()
        nameLabel.textColor = .black
        numberLabel = UILabel()
        
        
        addSubview(nameLabel)
        addSubview(numberLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: frame.width*0.1, y: 0, width: frame.width*0.5, height: frame.height)
        
        
        numberLabel.frame =  CGRect(x: 0, y: 0, width: frame.width*0.2, height: frame.height*0.75)
        numberLabel.center = CGPoint(x: frame.width*0.85, y: frame.height*0.5)
        numberLabel.textAlignment = .center
        numberLabel.textColor = UIColor.darkGray.withAlphaComponent(0.5)
        
        numberLabel.font = numberLabel.font.withSize(12)
        numberLabel.minimumScaleFactor = 0.1
        numberLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setup(name: String, numberOfQuestions: Int) {
        nameLabel.text = name
        numberLabel.text = String(numberOfQuestions)+" questions "
    }

}
