//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Сергей Лебедь on 13.09.2025.
//

import Foundation
typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
   
    lazy var newNameCategory: String = ""
    lazy var createNameCategory: String = ""
    lazy var categorySelect: String = "" {
        didSet {
            self.categorySelectUpdate?(categorySelect)
        }
    }
    var indexPath: Binding<IndexPath>?
    var categorySelectUpdate: Binding<String>?
    var categoriesUpdate: (() -> Void)?
    private let model: TrackerCategoryDataProvider
    
    init(for model: TrackerCategoryDataProvider) {
        self.model = model
        bind()
    }
    private func bind() {
        model.onCategoriesDidChange = { [weak self]  in
            self?.categoriesUpdate?()
        }
    }
    
    func fetchedObjects() -> Int {
        model.fetchedObjects()
    }
    
    func object(at indexPath: IndexPath) -> String {
       let coreDataCategory = model.object(at:indexPath)
        return coreDataCategory ?? ""
    }
    
    func createNewCategory(named name: String)throws {
        try?  model.createNewCategory(withName: name)
    }
    
    func deleteCategory(indexPath: IndexPath) throws {
        try? model.deleteCategory(indexPath: indexPath)
    }
    func updateCategory(indexPath: IndexPath, newName: String) throws {
        try? model.updateCategory(indexPath: indexPath, newName: newName)
    }
}
