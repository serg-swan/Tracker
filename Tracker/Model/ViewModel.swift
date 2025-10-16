//
//  ViewModel.swift
//  Tracker
//
//  Created by Сергей Лебедь on 13.09.2025.
//

import Foundation
typealias Binding<T> = (T) -> Void

final class ViewModel {
    //MARK: Public properties
    
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
    var recordUpdate: Binding<String>?
    
    //MARK: Public properties
    
    private let model: TrackerCategoryDataProvider
    private let modelRecord: TrackerRecordDataProvider
    
    //MARK: Initializers
    
    init(for model: TrackerCategoryDataProvider, modelRecord: TrackerRecordDataProvider) {
        self.model = model
        self.modelRecord = modelRecord
        bind()
    }

    private func bind() {
        model.onCategoriesDidChange = { [weak self]  in
            self?.categoriesUpdate?()
        }
        modelRecord.onRecordDidChange = { [weak self] count in
            self?.fetchCountAsString(count)
        }
    }
    
    //MARK: Public methods
    
    func fetchCountAsString(_ count: Int) {
        let text = "\(count)"
        recordUpdate?(text)
    }
    func loadRecordCount(){
        let count = modelRecord.fetchedObjects()
        fetchCountAsString(count)
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
