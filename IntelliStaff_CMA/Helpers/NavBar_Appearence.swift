//
//  NavBar_Appearence.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 20/07/25.
//
import SwiftUI

// ThemeManager.swift or AppAppearance.swift
struct AppAppearance {
    static func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .theme
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        UISearchBar.appearance().tintColor = UIColor.gray
        
        let searchTextFieldAppearance = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchTextFieldAppearance.backgroundColor = UIColor.white // background inside the search bar
        searchTextFieldAppearance.textColor = UIColor.black
        searchTextFieldAppearance.tintColor = UIColor.theme // cursor and selected text
        searchTextFieldAppearance.layer.cornerRadius = 10
        searchTextFieldAppearance.clipsToBounds = true

    }
}
