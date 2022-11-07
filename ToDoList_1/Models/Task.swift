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
        title = snapshotValue?["title"] as? String ?? ""
        userID = snapshotValue?["userId"] as? String ?? ""
        completed = snapshotValue?["completed"] as? Bool ?? false
        ref = snapshot.ref
    }
}
