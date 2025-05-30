//
//  CalendarViewModel.swift
//  DailyApp
//
//  Created by Ebrar Gül on 21.06.2024.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    
    @Published var items: [Item] = []
    @Published var searchText: String = ""
    
    func onAppear() {
        getItems()
    }
    
    func getItems() {
        PersistenceController2.shared.getByItems(query: searchText) { items in
            DispatchQueue.main.async {
                self.items = items
            }
        }
    }
}
