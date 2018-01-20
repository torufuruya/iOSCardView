//
//  ViewController.swift
//  iOSCardView
//
//  Created by Toru Furuya on 2018/01/20.
//  Copyright © 2018年 toru.furuya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let identifier = String(describing: CardViewCell.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        //Configure table view components
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        tableView.register(UINib.init(nibName: identifier, bundle: Bundle.main), forCellReuseIdentifier: identifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 10 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CardViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CardViewCell
        cell.textLabel?.text = "\(indexPath.section)-\(indexPath.row)"
        let numberOfRows = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        cell.numberOfRows = numberOfRows
        cell.indexPath = indexPath
        //Don't do this cause it waste more memory than layouts
        //cell.setNeedsDisplay()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.textLabel?.text = section == 0 ? "Tappable Section" : "Untappable Section"
        return headerView
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "section footer placeholder for description text about how payment process..."
        }
        return nil
    }
}

extension ViewController: UITableViewDelegate {

}
