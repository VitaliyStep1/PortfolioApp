//
//  MenuViewController.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 09.11.2021.
//

import UIKit
import Combine

class MenuViewController: UIViewController {
    var viewModel: MenuViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppeared()
    }
    
    private func bind() {
        viewModel.reloadItemsTableViewSubject.sink { [weak self] in
            self?.itemsTableView.reloadData()
        }.store(in: &subscriptions)
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsAmount = viewModel.takeRowsAmount()
        return rowsAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MenuCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MenuTableViewCell
        let cellInfo = viewModel.takeCellInfo(row: indexPath.row)
        cell.menuIconImageView.image = UIImage(named: cellInfo.iconImageName)
        cell.menuTitleLabel.text = cellInfo.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellWasSelected(row: indexPath.row)
    }
}
