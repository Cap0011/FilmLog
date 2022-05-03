//
//  FilmLogApp.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/27.
//

import SwiftUI

@main
struct FilmLogApp: App {
    
    let persistenceContainer = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TotalView()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}
