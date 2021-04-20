//
//  MailsTableViewController.swift
//  MS_Graph
//
//  Created by Ivan Ivanusic on 20.04.2021..
//

import UIKit
import MSGraphClientModels

class MailsTableViewController: UITableViewController {
    private let tableCellIdentifier = "messageCell"
    private var mails: [MSGraphMessage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    // Number of sections, always 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Return the number of events in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mails?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath)

        // Get the event that corresponds to the row
        let mail = mails?[indexPath.row]

        // Configure the cell
        cell.textLabel?.text = mail?.subject
        cell.detailTextLabel?.text = mail?.bodyPreview

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func setEvents(mails: [MSGraphMessage]?) -> Void {
        self.mails = mails
        self.tableView.reloadData()
    }
}
