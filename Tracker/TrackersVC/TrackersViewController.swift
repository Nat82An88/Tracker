import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    // MARK: - UI Elements
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
        let hasData = !categories.isEmpty
        placeholderStackView.isHidden = hasData
        
        // TODO: Обновить коллекцию/таблицу с трекерами
        // Здесь будет логика фильтрации трекеров по выбранной дате и обновления UI
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        // Создаем новый трекер для примера
        let newTracker = Tracker(
            title: "Новый трекер",
            color: "#FF0000",
            emoji: "🔥",
            schedule: Weekday.allCases,
            isHabit: true
        )
        
        let updatedCategories: [TrackerCategory]
        
        if let existingCategoryIndex = categories.firstIndex(where: { $0.title == "Пример категории" }) {
            let existingCategory = categories[existingCategoryIndex]
            let updatedTrackers = existingCategory.trackers + [newTracker]
            let updatedCategory = TrackerCategory(
                title: existingCategory.title,
                trackers: updatedTrackers
            )
            
            updatedCategories = categories.enumerated().map { index, category in
                index == existingCategoryIndex ? updatedCategory : category
            }
        } else {
            let newCategory = TrackerCategory(
                title: "Пример категории",
                trackers: [newTracker]
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
    func completeTracker(with id: UUID) {
        let record = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(record)
        updateUI()
    }
    
    func uncompleteTracker(with id: UUID) {
        completedTrackers.removeAll {
            $0.id == id && Calendar.current.isDate($0.date, inSameDayAs: datePicker.date)
        }
        updateUI()
    }
    
    func isTrackerCompletedToday(_ id: UUID) -> Bool {
        return completedTrackers.contains {
            $0.id == id && Calendar.current.isDate($0.date, inSameDayAs: datePicker.date)
        }
    }
}
