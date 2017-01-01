import Foundation
import Firebase

struct JobItem {
    
    let key: String
    let ref: FIRDatabaseReference?
    let ID: String
    let description : String
    let doneAt : Double
    let dueBy : Double
    let isInProgress : Bool
    
    // let name: String
    // let addedByUser: String
    // var completed: Bool
    
    /*init(name: String, addedByUser: String, completed: Bool, key: String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.ref = nil
    } */
    
    init(ID: String, description: String, doneAt: Double, dueBy : Double, isInProgress: Bool, key: String = "") {
        self.key = key
        self.ID = ID
        self.description = description
        self.doneAt = doneAt
        self.dueBy = dueBy
        self.isInProgress = isInProgress
        self.ref = nil
    }
    
 /*   init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    */
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        ID = snapshotValue["ID"] as! String
        description = snapshotValue["description"] as! String
        if snapshotValue["dueBy"] != nil {
           dueBy = snapshotValue["dueBy"] as! Double
        } else {
            dueBy = 0
        }
        if snapshotValue["doneAt"] != nil {
            doneAt = snapshotValue["doneAt"] as! Double
        } else {
            doneAt = 0
        }
        if snapshotValue["isInProgress"] != nil {
            isInProgress = snapshotValue["isInProgress"] as! Bool
        } else {
            isInProgress = false
        }

        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "ID": ID,
            "description" : description,
            "doneAt" : doneAt,
            "dueBy" : dueBy,
            "isInProgress" : isInProgress
           /* "name": name,
            "addedByUser": addedByUser,
            "completed": completed */
        ]
    }
    
    func dueByString () -> String {
        let date = Date(timeIntervalSince1970: dueBy)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEE, dd MMM hh:mm a"
        return dayTimePeriodFormatter.string(from: date)
    }
    
    func writeToDone () {
        
    }
    
}
