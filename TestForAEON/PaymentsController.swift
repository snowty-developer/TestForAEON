//
//  PaymentsController.swift
//  TestForAEON
//
//  Created by Александр Зубарев on 01.11.2021.
//

import UIKit

class PaymentsController: UITableViewController {

    var payments: [Payment] = []

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PaymentCell
        cell.initCell(cell: payments[indexPath.row])

        return cell
    }
}
