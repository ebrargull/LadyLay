//
//  Binding+Extensions.swift
//  DailyApp
//
//  Created by Ebrar Gül on 19.06.2024.
//

/*import Foundation
import SwiftUI

extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
    
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
            }
        )
    }
}*/
