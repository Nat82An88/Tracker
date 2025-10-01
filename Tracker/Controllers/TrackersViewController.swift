import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var filteredCategories: [TrackerCategory] = []
    private var searchText: String = ""
    private var searchController: UISearchController!
    private var trackerStore: TrackerStore!
    private var trackerCategoryStore: TrackerCategoryStore!
    private var trackerRecordStore: TrackerRecordStore!
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var placeholderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var placeholderView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dizzy")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
            let label = UILabel()
            label.text = Localizable.noTrackersPlaceholder
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label.textColor = UIColor(resource: .ypBlackDay)
            label.textAlignment = .center
            return label
        }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        
        trackerStore = appDelegate.trackerStore
        trackerCategoryStore = appDelegate.trackerCategoryStore
        trackerRecordStore = appDelegate.trackerRecordStore
        
        setupStoreObservers()
        
        loadData()
        setupUI()
        updateUI()
        setupGestureRecognizer()
        removeNavigationBarSeparator()
    }
    
    // MARK: - Store Observers
    private func setupStoreObservers() {
        trackerCategoryStore.onCategoriesDidChange = { [weak self] categories in
            self?.categories = categories
            self?.updateUI()
        }
        
        trackerRecordStore.onRecordsDidChange = { [weak self] records in
            self?.completedTrackers = records
            self?.updateUI()
        }
    }
    
    // MARK: - Data Loading
    private func loadData() {
        do {
            categories = try trackerCategoryStore.fetchAllCategories()
            completedTrackers = try trackerRecordStore.fetchAllRecords()
            print("DEBUG: Loaded \(categories.count) categories, \(categories.flatMap { $0.trackers }.count) trackers, \(completedTrackers.count) records")
        } catch {
            print("Error loading data: \(error)")
        }
    }
    
    // MARK: - Tracker Completion Methods
    private func completeTracker(with id: UUID) {
        let selectedDate = datePicker.date
        let today = Date()
        
        if selectedDate > today {
            print(Localizable.futureDateError)
            return
        }
        
        let record = TrackerRecord(id: id, date: selectedDate)
        
        do {
            try trackerRecordStore.addRecord(record)
            completedTrackers.append(record)
            updateUI()
        } catch {
            print("Error completing tracker: \(error)")
        }
    }
    
    private func uncompleteTracker(with id: UUID) {
        let selectedDate = datePicker.date
        
        do {
            try trackerRecordStore.removeRecord(with: id, date: selectedDate)
            completedTrackers.removeAll {
                $0.id == id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
            }
            updateUI()
        } catch {
            print("Error uncompleting tracker: \(error)")
        }
    }
    
    private func isTrackerCompletedToday(_ id: UUID) -> Bool {
        let selectedDate = datePicker.date
        return completedTrackers.contains {
            $0.id == id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }
    
    private func getCompletionCount(for trackerId: UUID) -> Int {
        do {
            return try trackerRecordStore.completionCount(for: trackerId)
        } catch {
            print("Error getting completion count: \(error)")
            return 0
        }
    }
    
    // MARK: - Add Tracker
    private func addTracker(_ tracker: Tracker, toCategory categoryTitle: String) {
        do {
            try trackerStore.addTracker(tracker, to: categoryTitle)
            print("DEBUG: Tracker added successfully")
            loadData()
            updateUI()
        } catch {
            print("Error adding tracker: \(error)")
        }
    }
    
    // MARK: - Navigation Bar Separator
    private func removeNavigationBarSeparator() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    // MARK: - Gesture Recognizer
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupCollectionView()
        setupPlaceholder()
    }
    
    private func setupNavigationBar() {
        title = Localizable.trackersTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let addButton = UIBarButtonItem(
            image: UIImage(resource: .plus),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        addButton.tintColor = UIColor(resource: .ypBlackDay)
        navigationItem.leftBarButtonItem = addButton
        
        let datePickerContainer = UIView()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePickerContainer.addSubview(datePicker)
        let datePickerWidth: CGFloat = 120
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerContainer.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor),
            datePickerContainer.widthAnchor.constraint(equalToConstant: datePickerWidth)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePickerContainer)
        
        setupSearchController()
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = Localizable.searchPlaceholder
        searchController.searchBar.searchTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        searchController.searchBar.searchTextField.textColor = .gray
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupPlaceholder() {
        placeholderStackView.addArrangedSubview(placeholderView)
        placeholderStackView.addArrangedSubview(placeholderLabel)
        view.addSubview(placeholderStackView)
        
        NSLayoutConstraint.activate([
            placeholderView.widthAnchor.constraint(equalToConstant: 80),
            placeholderView.heightAnchor.constraint(equalToConstant: 80),
            
            placeholderStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            placeholderStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - UI Update
    private func updateUI() {
        filterTrackers()
        
        let hasData = filteredCategories.contains { !$0.trackers.isEmpty }
        placeholderStackView.isHidden = hasData
        collectionView.isHidden = !hasData
        
        collectionView.reloadData()
    }
    
    private func filterTrackers() {
        let selectedDate = datePicker.date
        let weekday = Calendar.current.component(.weekday, from: selectedDate)
        
        print("Filtering for date: \(selectedDate), weekday: \(weekday)")
        
        var dateFilteredCategories = categories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let containsWeekday = tracker.schedule.contains { $0.rawValue == weekday }
                print("Tracker '\(tracker.title)' schedule: \(tracker.schedule.map { $0.rawValue }), contains weekday \(weekday): \(containsWeekday)")
                return containsWeekday
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        
        if !searchText.isEmpty {
            dateFilteredCategories = dateFilteredCategories.map { category in
                let filteredTrackers = category.trackers.filter { tracker in
                    tracker.title.lowercased().contains(searchText.lowercased())
                }
                return TrackerCategory(title: category.title, trackers: filteredTrackers)
            }
        }
        
        filteredCategories = dateFilteredCategories.filter { !$0.trackers.isEmpty }
        
        print("Final filtered categories: \(filteredCategories.count)")
        for category in filteredCategories {
            print("Category '\(category.title)': \(category.trackers.count) trackers")
        }
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        let habitVC = HabitViewController(trackerCategoryStore: trackerCategoryStore)
        habitVC.onSave = { [weak self] tracker, categoryTitle in
            self?.addTracker(tracker, toCategory: categoryTitle)
        }
        
        let navController = UINavigationController(rootViewController: habitVC)
        present(navController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        updateUI()
    }
    
    func handleTrackerCompletion(_ trackerId: UUID, _ isCompleted: Bool) {
        if isCompleted {
            completeTracker(with: trackerId)
        } else {
            uncompleteTracker(with: trackerId)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.identifier,
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        let isCompleted = isTrackerCompletedToday(tracker.id)
        let completionCount = getCompletionCount(for: tracker.id)
        
        cell.configure(
            with: tracker,
            isCompletedToday: isCompleted,
            completionCount: completionCount
        ) { [weak self] trackerId, isCompleted in
            self?.handleTrackerCompletion(trackerId, isCompleted)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = max(0, collectionView.frame.width - 16)
        let cellWidth = availableWidth / 2
        return CGSize(width: max(0, cellWidth), height: max(0, 148))
    }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        updateUI()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
