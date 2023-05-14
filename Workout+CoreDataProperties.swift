//
//  Workout+CoreDataProperties.swift
//  WorkOutApp
//
//  Created by Joao Barros on 13/05/23.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var workoutTitle: String?
    @NSManaged public var createdLabel: Date?
    @NSManaged public var descriptionLabel: String?

}

extension Workout : Identifiable {

}
