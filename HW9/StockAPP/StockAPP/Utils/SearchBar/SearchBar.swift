//
//  SearchBar.swift
//  SwiftUI_Search_Bar_in_Navigation_Bar
//
//  Created by Geri Borbás on 2020. 04. 27..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//
import SwiftUI

class SearchBar: NSObject, ObservableObject {
    
    @Published var text: String = ""
    var startSearch: (String) -> Void = {_ in return}
    var cancelSearch: () -> Void = {}
    var isSearching: Bool {
        text.count != 0
    }
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override init() {
        super.init()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
    }
    
    func initQuery(startSearch: @escaping (String) -> Void) {
        self.startSearch = startSearch
    }
    
    func initCancel(cancelSearch: @escaping () -> Void) {
        self.cancelSearch = cancelSearch
    }
}

extension SearchBar: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Publish search bar text changes.
        if let searchBarText = searchController.searchBar.text {
            if searchBarText != self.text {
                self.text = searchBarText
                if !searchBarText.isEmpty {
                    self.startSearch(self.text)
                }
            }
        } else {
            self.cancelSearch()
        }
    }
    
    func searchBarSearchButtonClicked(_: UISearchBar) {
        self.startSearch(self.text)
    }
    
    func searchBarCancelButtonClicked(_: UISearchBar) {
        self.text = ""
        self.cancelSearch()
    }
}

struct SearchBarModifier: ViewModifier {
    
    let searchBar: SearchBar
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver { viewController in
                    viewController.navigationItem.searchController = self.searchBar.searchController
                }
                    .frame(width: 0, height: 0)
            )
    }
}

extension View {
    func add(_ searchBar: SearchBar) -> some View {
        return self.modifier(SearchBarModifier(searchBar: searchBar))
    }
}
