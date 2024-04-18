//
//  SymptomTrackerViewController.swift
//  Symptom Tracker
//
//  Created by sq022 on 4/17/24.
//

import UIKit
import CareKit
import CareKitStore

final class SymptomTrackerViewController: OCKDailyPageViewController {
    
    
    init(store: OCKStore = CareStoreReferenceManager.shared.synchronizedStoreManager) {
        super.init(store: store)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Track daily symptoms"
    }
    
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController,
                                          prepare listViewController: OCKListViewController, for date: Date) {
        
        let identifiers = CareStoreReferenceManager.TaskIdentifiers.allCases.map { $0.rawValue }
        var query = OCKTaskQuery(for: date)
        query.ids = identifiers
        query.excludesTasksWithNoEvents = true
        
        store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            guard let tasks = try? result.get() else { return }
            print(tasks)
            tasks.forEach { task in
                switch task.id {
                case CareStoreReferenceManager.TaskIdentifiers.coughingEpisodes.rawValue:
                    let coughingCard = OCKButtonLogTaskViewController(query: .init(for: date),
                                                                      store: self.store)
                    listViewController.appendViewController(coughingCard, animated: false)
                default: return
                }
            }
        }
    }
}
