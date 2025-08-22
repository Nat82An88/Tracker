import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    private var filteredCategories: [TrackerCategory] = []
    
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
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
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
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        return searchBar
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupSearchBar()
        setupCollectionView()
        setupPlaceholder()
    }
    
    private func setupNavigationBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Add button
        let addButton = UIBarButtonItem(
            image: UIImage(named: "plus"),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        addButton.tintColor = .ypBlackDay
        navigationItem.leftBarButtonItem = addButton
        
        // DatePicker container
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
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
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
        filterTrackersBySelectedDate()
        
        let hasData = !filteredCategories.contains { !$0.trackers.isEmpty }
        placeholderStackView.isHidden = hasData
        collectionView.isHidden = !hasData
        
        collectionView.reloadData()
    }
    
    private func filterTrackersBySelectedDate() {
        let selectedDate = datePicker.date
        let weekday = Calendar.current.component(.weekday, from: selectedDate)
        
        filteredCategories = categories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.schedule.contains { $0.rawValue == weekday }
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        let habitVC = HabitViewController()
        habitVC.onSave = { [weak self] tracker, categoryTitle in
            self?.addTracker(tracker, toCategory: categoryTitle)
        }
        
        let navController = UINavigationController(rootViewController: habitVC)
        present(navController, animated: true)
    }
    
    private func addTracker(_ tracker: Tracker, toCategory categoryTitle: String) {
        let updatedCategories: [TrackerCategory]
        
        if let existingCategoryIndex = categories.firstIndex(where: { $0.title == categoryTitle }) {
            let existingCategory = categories[existingCategoryIndex]
            let updatedTrackers = existingCategory.trackers + [tracker]
            let updatedCategory = TrackerCategory(
                title: existingCategory.title,
                trackers: updatedTrackers
            )
            
            updatedCategories = categories.enumerated().map { index, category in
                index == existingCategoryIndex ? updatedCategory : category
            }
        } else {
            let newCategory = TrackerCategory(
                title: categoryTitle,
                trackers: [tracker]
            )
            updatedCategories = categories + [newCategory]
        }
        
        categories = updatedCategories
        updateUI()
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        updateUI()
    }
    
    // MARK: - Tracker Completion Methods
    private func completeTracker(with id: UUID) {
        let selectedDate = datePicker.date
        let today = Date()
        
        if selectedDate > today {
            print("Нельзя отмечать трекеры для будущих дат")
            return
        }
        
        let record = TrackerRecord(id: id, date: selectedDate)
        completedTrackers.append(record)
        updateUI()
    }
    
    private func uncompleteTracker(with id: UUID) {
        let selectedDate = datePicker.date
        completedTrackers.removeAll {
            $0.id == id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
        updateUI()
    }
    
    private func isTrackerCompletedToday(_ id: UUID) -> Bool {
        let selectedDate = datePicker.date
        return completedTrackers.contains {
            $0.id == id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }
    
    private func getCompletionCount(for trackerId: UUID) -> Int {
        return completedTrackers.filter { $0.id == trackerId }.count
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
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
}
