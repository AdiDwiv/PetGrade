//
//  Pet+CoreDataProperties.swift
//  petGrade
//
//  Created by Aditya Dwivedi on 1/6/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import Foundation
import CoreData


extension Pet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pet> {
        return NSFetchRequest<Pet>(entityName: "Pet");
    }

    @NSManaged public var name: String?
    @NSManaged public var wellness: Int32
    @NSManaged public var dateOpened: NSDate?
    @NSManaged public var dateStreak: NSDate?
    
    func changeWellness(change: Int) {
        wellness += change
        if wellness < 0 {
            wellness = 0
        }
        else if wellness > 100 {
            wellness = 100
        }
    }
    
    func dayDifference(start: Date, end: Date) -> Int {
        let calendar = NSCalendar.current
        let component = calendar.dateComponents([Calendar.Component.day], from: start, to: end)
        return component.day!
    }
    
    func save(managedContext: NSManagedObjectContext)  {
        do {
            try managedContext.save()
        } catch {
            print("Save error")
        }
    }
}
