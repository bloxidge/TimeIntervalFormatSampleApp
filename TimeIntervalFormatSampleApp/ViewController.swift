//
//  ViewController.swift
//  TimeIntervalFormatSampleApp
//
//  Created by Peter Bloxidge on 12/07/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var tableView: UITableView!

    private var timeInterval: TimeInterval?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        processTimeString(text)
    }

    @IBAction func goPressed() {
        guard let text = textField.text else { return }
        processTimeString(text)
    }

    private func processTimeString(_ text: String) {
        if text.contains(":") {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(secondsFromGMT: 0)!
            formatter.dateFormat = "HH:mm:ss"
            let date = formatter.date(from: text)
            timeInterval = date?.timeIntervalSince1970
        } else {
            timeInterval = TimeInterval(text)
        }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeIntervalFormat.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let formatType = TimeIntervalFormat.allCases[indexPath.item]
        if let timeInterval = timeInterval {
            cell.textLabel?.text = formatType.accessibilityString(for: timeInterval)
        } else {
            cell.textLabel?.text = "?"
        }
        return cell
    }
}
