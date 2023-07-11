import UIKit


class HabitsViewController: UIViewController {

  static var tempHabit: Habit?

    static var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Colors.lightgray.color

        return collectionView
    }()


    private var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)

        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        setupAddButton()
        setupView()
        setupConstraints()
        setupCV()

    }


    func setupView() {
        view.backgroundColor = Colors.lightgray.color
        view.addSubview(HabitsViewController.collectionView)

        navigationItem.title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
//        navigationController?.navigationBar.standardAppearance = UINavigationBarAppearance()


    }

    func setupCV() {

        HabitsViewController.collectionView.dataSource = self
        HabitsViewController.collectionView.delegate = self

        HabitsViewController.collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.id)


        HabitsViewController.collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.id)


    }

    func setupConstraints() {

        let safeAreaLayoutGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            HabitsViewController.collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 22),
            HabitsViewController.collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            HabitsViewController.collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            HabitsViewController.collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),

        ])


    }

    func setupAddButton() {
        let addButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = addButtonItem
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    @objc func addButtonTapped() {

        let habitVC = HabitViewController()
        habitVC.title = "Создать"
        let habitNC = UINavigationController(rootViewController: habitVC)
        habitNC.modalPresentationStyle = .fullScreen
        present(habitNC, animated: true)

        print("Button tapped")
        
    }

}

extension HabitsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    func numberOfSections(in collectionView: UICollectionView) -> Int {

        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        } else {
            return HabitsStore.shared.habits.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.id, for: indexPath) as! ProgressCollectionViewCell

            cell.setup()
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.id, for: indexPath) as! HabitCollectionViewCell
            let habit = HabitsStore.shared.habits[indexPath.row]
            cell.setup(with: habit)
            HabitsViewController.tempHabit = habit
//            HabitsViewController.tempHabit = habit

//            let tableViewController = HabitDetailsViewController()
//            tableViewController.title = habit.name // Установите значение заголовка


            cell.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTap(_:)))
            cell.addGestureRecognizer(tapGesture)


//            HabitsViewController.tempHabit = habit
            return cell
        default:
            return UICollectionViewCell()
        }
    }


    @objc func cellTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? UICollectionViewCell else { return }
        guard let selectedIndexPath = HabitsViewController.collectionView.indexPath(for: cell) else { return }
        let habit = HabitsStore.shared.habits[selectedIndexPath.row]

        let habitDetailsViewController = HabitDetailsViewController()
//        habitDetailsViewController.title = habit.name // Установите значение заголовка
        habitDetailsViewController.habit = habit
//        habitDetailsViewController.tempTitle = habit.name

        let habitDetailsNC = UINavigationController(rootViewController: habitDetailsViewController)
        habitDetailsNC.modalPresentationStyle = .fullScreen
        present(habitDetailsNC, animated: true)

        print("cell tapped")
    }



//    @objc func cellTap() {
//
//        let habitDetailNC = UINavigationController(rootViewController: HabitDetailsViewController())
////        habitDetailNC.title = HabitsViewController.tempHabit?.name
//        habitDetailNC.modalPresentationStyle = .fullScreen
//        present(habitDetailNC, animated: true)
//
//        print("date cell tapped")
//    }


//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedTitle = HabitsStore.shared.habits[indexPath.row].name // Заголовок выбранной ячейки UICollectionView
//
//        let tableViewController = HabitDetailsViewController()
//        tableViewController.title = selectedTitle // Установите значение заголовка
//        navigationController?.pushViewController(tableViewController, animated: true)
//    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch indexPath.section {
        case 0:
            let width = collectionView.frame.width - 32
            return CGSize(width: width, height: 60)
        case 1:
            let width = collectionView.frame.width - 32
            return CGSize(width: width, height: 130)
        default:
            return CGSize(width: 0, height: 0)

        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 8, bottom: 22, right: 8)
    }


}
