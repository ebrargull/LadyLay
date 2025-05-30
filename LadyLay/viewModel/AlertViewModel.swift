//
//  AlertViewModel.swift
//  DailyApp
//
//  Created by Ebrar Gül on 24.05.2024.
//

import Foundation

class AlertViewModel : ObservableObject {
    @Published var showAlert = false
    @Published var title = ""
    @Published var message = ""
    @Published var defaultButtonTitle = "ok"


    func showAlert(title: String, message: String){
        self.title = title
        self.message = message
        self.showAlert = true
        
    }
}
