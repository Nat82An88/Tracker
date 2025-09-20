import Foundation

final class CategoriesViewModel {
    
    // MARK: - Properties
    private let trackerCategoryStore: TrackerCategoryStore
    private(set) var categories: [TrackerCategory] = []
    private(set) var selectedCategory: TrackerCategory?
    
    // MARK: - Bindings
    var onCategoriesUpdate: (() -> Void)?
    var onCategorySelect: ((TrackerCategory) -> Void)?
    var onEmptyStateChange: ((Bool) -> Void)?
    
    // MARK: - Initialization
    init(trackerCategoryStore: TrackerCategoryStore) {
        self.trackerCategoryStore = trackerCategoryStore
        setupObservers()
        loadCategories()
    }
    
    // MARK: - Setup
    private func setupObservers() {
        trackerCategoryStore.onCategoriesDidChange = { [weak self] categories in
            self?.categories = categories
            self?.onCategoriesUpdate?()
            self?.onEmptyStateChange?(categories.isEmpty)
        }
    }
    
    // MARK: - Public Methods
    func loadCategories() {
        do {
            categories = try trackerCategoryStore.fetchAllCategories()
            onCategoriesUpdate?()
            onEmptyStateChange?(categories.isEmpty)
        } catch {
            print("Error loading categories: \(error)")
        }
    }
    
    func selectCategory(at index: Int) {
        guard index >= 0 && index < categories.count else { return }
        selectedCategory = categories[index]
        if let selectedCategory = selectedCategory {
            onCategorySelect?(selectedCategory)
        }
    }
    
    func getCategoryTitle(at index: Int) -> String? {
        guard index >= 0 && index < categories.count else { return nil }
        return categories[index].title
    }
    
    func getCategoriesCount() -> Int {
        return categories.count
    }
    
    func isCategorySelected(at index: Int) -> Bool {
        guard index >= 0 && index < categories.count else { return false }
        return categories[index].title == selectedCategory?.title
    }
    
    func addNewCategory(title: String) {
        let newCategory = TrackerCategory(title: title, trackers: [])
        do {
            try trackerCategoryStore.addCategory(newCategory)
        } catch {
            print("Error adding category: \(error)")
        }
    }
}
