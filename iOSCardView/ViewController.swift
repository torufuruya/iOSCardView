//
//  ViewController.swift
//  iOSCardView
//
//  Created by Toru Furuya on 2018/01/20.
//  Copyright © 2018年 toru.furuya. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let identifier = String(describing: CardViewCell.self)

    private var appData: [AppData] = []
    private var totalAmount = 0

    private let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Configure table view components
        tableView.backgroundColor = .white
        tableView.register(UINib.init(nibName: identifier, bundle: Bundle.main), forCellReuseIdentifier: identifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        refresh.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "Fetching Application Data...")
        self.tableView.refreshControl = refresh

        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc private func refresh(_ sender: Any) {
        loadData()
    }

    private func loadData() {
        Alamofire.request("http://www.mocky.io/v2/5a275eb23000006e3c0e8a5e").responseJSON { response in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { self.refresh.endRefreshing() }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            guard let data = response.data else {
                return
            }
            do {
                self.appData = try decoder.decode([AppData].self, from: data)
                self.totalAmount = self.appData.map({$0.amount}).reduce(0){$0 + $1}
                self.tableView.reloadData()
            } catch {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

struct AppData : Codable {
    let id: String
    let amount: Int
    let currency: String
    let description: String
    let kind: String
    let pushed_at: String
}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appData.count > 0 {
            return section == 0 ? appData.count : 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CardViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CardViewCell

        cell.numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        cell.indexPath = indexPath

        if indexPath.section == 0 {
            let entity = appData[indexPath.row]
            cell.configure(appData: entity)
            cell.isTappable = true
        } else {
            cell.descriptionLabel?.text = "Grand Total"
            cell.amountLabel.text = "¥\(totalAmount)"
            cell.kindContainerView.isHidden = true
            cell.publishedAt.isHidden = true
            cell.isTappable = false
        }
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

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return indexPath
        }
        //Untapptable section
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = appData[indexPath.row]
        showAlert(title: entity.id, message: entity.description)
    }
}
