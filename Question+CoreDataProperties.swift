//
//  Question+CoreDataProperties.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 1/5/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question");
    }

    @NSManaged public var answer: String?
    @NSManaged public var hasImage: Bool
    @NSManaged public var questionImage: NSData?
    @NSManaged public var questionText: String?
    @NSManaged public var quiz: Quiz?

}
