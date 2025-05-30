//
//  DialogAlertViewModel.swift
//  DailyApp
//
//  Created by Ebrar Gül on 21.06.2024.
//

import SwiftUI

class DialogAlertViewModel: ObservableObject {
    
    @Published var showingAlert: Bool = false
    
    @Published var title = ""
    @Published var message = ""
    @Published var okTitle = ""
    @Published var dismissTitle = ""
    @Published var yesTitle = ""
    var completion: (() -> Void)? = nil
    
    func showAlert(title: String, message: String){
        self.showingAlert = true
        self.title = title
        self.dismissTitle = "dismiss"
        self.okTitle = "delete"
        self.yesTitle = ""
    }
    
    func showAlert(title: String, yesTitle: String, dismissTitle: String, okTitle: String, completion: @escaping () -> Void) {
        self.completion = completion
        self.title = title
        self.yesTitle = yesTitle
        self.dismissTitle = dismissTitle
        self.okTitle = okTitle
        self.showingAlert = true
    }
    
    func onClicked(){
        completion?()
    }
}

