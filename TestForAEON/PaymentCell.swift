//
//  PaymentCell.swift
//  TestForAEON
//
//  Created by Александр Зубарев on 01.11.2021.
//

import UIKit

class PaymentCell: UITableViewCell {

    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    
    func initCell (cell: Payment) {
        descLabel.text = cell.desc!
        amountLabel.text = cell.amount!
        currencyLabel.text = cell.currency!
        createdLabel.text = cell.created!
    }

}
