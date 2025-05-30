//
//  WebViewWithNavigationUIView.swift
//  DailyApp
//
//  Created by Ebrar Gül on 21.06.2024.
//

import SwiftUI

struct WebViewWithNavigationUIView: View {
    
    @Binding var url: String
    @Binding var title: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        NavigationView{
            WebUIView(url: url, title: title)
                .navigationBarItems(trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "xmark").foregroundColor(.gray)
                })
                .navigationBarTitle(Text(title), displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    struct cancelButton: View {
        var body: some View {
            Text("cancel")
                .foregroundColor(.secondary)
                .font(.some(Font.system(.body, design: .rounded)))
                .bold()
                .padding(8)
        }
    }
}
