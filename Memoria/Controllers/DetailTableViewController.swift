//
//  DetailTableViewController.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 27/10/20.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    let titleSubtitleCellIdentifier: String = "TitleSubtitleCell"
    let subtitleCellIdentifier: String = "SubtitleCell"
    let photoCellIdentifier: String = "PhotoCell"
    let textViewIdentifier: String = "TextViewCell"
    let iconButtonCellIdentifier: String = "IconButtonCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
            
        let nibTitle = UINib.init(nibName: self.titleSubtitleCellIdentifier, bundle: nil)
        self.tableView.register(nibTitle, forCellReuseIdentifier: self.titleSubtitleCellIdentifier)
        
        let nibTextView = UINib.init(nibName: self.textViewIdentifier, bundle: nil)
        self.tableView.register(nibTextView, forCellReuseIdentifier: self.textViewIdentifier)
        
        let nibSubtitle = UINib.init(nibName: self.subtitleCellIdentifier, bundle: nil)
        self.tableView.register(nibSubtitle, forCellReuseIdentifier: self.subtitleCellIdentifier)
        
        let nibPhoto = UINib.init(nibName: self.photoCellIdentifier, bundle: nil)
        self.tableView.register(nibPhoto, forCellReuseIdentifier: self.photoCellIdentifier)
        
        let nibIconButton = UINib.init(nibName: self.iconButtonCellIdentifier, bundle: nil)
        self.tableView.register(nibIconButton, forCellReuseIdentifier: self.iconButtonCellIdentifier)
        
        self.navigationItem.title = "Conta pra mim!"
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
  
    // swiftlint:disable cyclomatic_complexity
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: self.subtitleCellIdentifier, for: indexPath)
            if let cellType = cell as? SubtitleCell {
                return cellType
            }
        } else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: self.textViewIdentifier, for: indexPath)
            if let cellType = cell as? TextViewCell {
                return cellType
            }
        } else if indexPath.row == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: self.titleSubtitleCellIdentifier, for: indexPath)
            if let cellType = cell as? TitleSubtitleCell {
                return cellType
            }
        } else if indexPath.row == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: self.titleSubtitleCellIdentifier, for: indexPath)
            if let cellType = cell as? TitleSubtitleCell {
                return cellType
            }
        } else if indexPath.row == 4 {
            cell = tableView.dequeueReusableCell(withIdentifier: self.photoCellIdentifier, for: indexPath)
            if let cellType = cell as? PhotoCell {
                return cellType
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: self.iconButtonCellIdentifier, for: indexPath)
            if let cellType = cell as? IconButtonCell {
                return cellType
            }
        }
        return cell
    }
}