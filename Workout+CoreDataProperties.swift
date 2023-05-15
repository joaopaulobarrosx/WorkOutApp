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

    @nonobjc public class func fetchRequest(forUserUid userUid: String) -> NSFetchRequest<Workout> {
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userUid == %@", userUid)
        return fetchRequest
    }

    @NSManaged public var workoutTitle: String?
    @NSManaged public var createdLabel: Date?
    @NSManaged public var descriptionLabel: String?
    @NSManaged public var userUid: String?
    @NSManaged public var uid: UUID?

}

extension Workout : Identifiable {

}


