//
//  CareStore.swift
//  Symptom Tracker
//
//  Created by sq022 on 4/17/24.
//

import Foundation
import CareKit
import CareKitStore

// Singleton wrapper to hold a reference to the store and and task identifiers
// This is probably not necessary, but this is what was done when using the deprecated OCKSynchronizedStoreManager
// The schedule code is from https://swiftpackageindex.com/carekit-apple/carekit/main/documentation/carekit/creating-and-displaying-tasks-for-a-patient

final class CareStoreReferenceManager {
    
    enum TaskIdentifiers: String, CaseIterable {
        case coughingEpisodes
    }
    

    static let shared = CareStoreReferenceManager()
    
    // Manages synchronization of a CoreData store
    lazy var synchronizedStoreManager: OCKStore = {
        let store = OCKStore(name: "COVID19Tracker")
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let atBreakfast = Calendar.current.date(byAdding: .hour, value: 8, to: startOfDay)!
        let dailyAtBreakfast = OCKScheduleElement(start: atBreakfast, end: nil, interval: DateComponents(day: 1))
        // Multiple schedules can be composed and added
        var schedule = OCKSchedule(composing: [dailyAtBreakfast])
        var coughingTask = OCKTask(id: TaskIdentifiers.coughingEpisodes.rawValue,
                                   title: "Coughing Episodes",
                                   carePlanUUID: nil,
                                   schedule: schedule)
        //Multiple tasks can be added to the store
        store.addTasks([coughingTask])
        return store
    }()
    
    private init() {
        
        
    }
    
    
}
