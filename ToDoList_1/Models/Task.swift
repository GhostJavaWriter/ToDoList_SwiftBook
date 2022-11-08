//
//  Task.swift
//  ToDoList_1
//
//  Created by Bair Nadtsalov on 7.11.2022.
//

import Foundation
import Firebase

struct Task {
    
    let title: String
    let userID: String
    let ref: DatabaseReference?
    var completed = false
    
    init(title: String, userID: String) {
        self.title = title
        self.userID = userID
        ref = nil
    }
    
    init(snapshot: DataSnapshot) {

        let snapshotValue = snapshot.value as? [String: AnyObject]
        title = snapshotValue?["title"] as? String ?? "unknown title"
        userID = snapshotValue?["userId"] as? String ?? "error id"
        completed = snapshotValue?["completed"] as? Bool ?? false
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["title": title, "userId": userID, "completed": completed]
    }
}
