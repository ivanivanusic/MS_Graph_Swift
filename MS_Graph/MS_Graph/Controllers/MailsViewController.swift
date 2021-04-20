//
//  MailsViewController.swift
//  MS_Graph
//
//  Created by Ivan Ivanusic on 20.04.2021..
//

import UIKit
import MSGraphClientModels

class MailsViewController: UIViewController {
    private let spinner = SpinnerViewController()
    private var tableViewController: MailsTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.spinner.start(container: self)
        
        // Calculate the start and end of the current week
        let timeZone = GraphToIana.getIanaIdentifier(graphIdentifer: GraphManager.instance.userTimeZone)
        let now = Date()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: timeZone)!
        
        let startOfWeek = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: now).date!
        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
        
        // Convert start and end to ISO 8601 strings
        let isoFormatter = ISO8601DateFormatter()
        let viewStart = isoFormatter.string(from: startOfWeek)
        let viewEnd = isoFormatter.string(from: endOfWeek)

        GraphManager.instance.getFlaggedMails(viewStart: viewStart, viewEnd: viewEnd) {
            (mailsArray: [MSGraphMessage]?, error: Error?) in
            DispatchQueue.main.async {
                self.spinner.stop()

                guard let mails = mailsArray, error == nil else {
                    // Show the error
                    let alert = UIAlertController(title: "Error getting events",
                                                  message: error.debugDescription,
                                                  preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                
                self.tableViewController?.setEvents(mails: mails)
            }
        }
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Save reference to the contained table view
        if segue.destination is MailsTableViewController {
            self.tableViewController = segue.destination as? MailsTableViewController
        }
    }
}

