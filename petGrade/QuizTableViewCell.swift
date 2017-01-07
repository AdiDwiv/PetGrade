//
//  QuizTableViewCell.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 1/3/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {
    
    var questionLabel: UILabel!
    var questionImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white.withAlphaComponent(0.25)
        
        questionLabel = UILabel()
        questionImageView = UIImageView()
        questionImageView.clipsToBounds = true
        questionImageView.image = UIImage(named: "defaultCellImage")
        
        questionLabel.textColor = .black
        questionLabel.text = "<Default text>"
        
        addSubview(questionImageView)
        addSubview(questionLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        questionImageView.frame = CGRect(x: 0, y: 0, width: frame.width*0.45, height: frame.height*0.8)
        questionImageView.center = CGPoint(x: frame.width*0.25, y: frame.height*0.5)
        questionImageView.layer.cornerRadius = 5
        
        
        questionLabel.frame =  CGRect(x: frame.width*0.5, y: 0, width: frame.width*0.45, height: frame.height)
        questionLabel.center = CGPoint(x: frame.width*0.75, y: frame.height*0.5)
        questionLabel.textAlignment = .center
        
    }
    
    func setup(label: String, image: UIImage?) {
        if let cellImage = image {
            questionImageView.image = cellImage
        }
        questionLabel.text = label
    }

}
