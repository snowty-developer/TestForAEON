//
//  PaymentInfoModel.swift
//  TestForAEON
//
//  Created by Александр Зубарев on 30.10.2021.
//

import Foundation
import UIKit

struct PaymentsFromJSON: Decodable {
    var success: String
    var response: [Payment]
}

struct Payment: Decodable {
    var desc: String?
    var amount: String?
    var currency: String?
    var created: String?
    
    enum CodingKeys: String, CodingKey {
            case desc
            case amount
            case currency
            case created
        }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.desc = try container.decode(String.self, forKey: .desc)
        
        do {
            let stringAmount = try container.decode(String.self, forKey: .amount)
            self.amount = stringAmount.contains(".") ? stringAmount : stringAmount.appending(".00")
        } catch {
            let doubleAmount = try container.decode(Double.self, forKey: .amount)
            self.amount = String(format:"%.2f", doubleAmount)
        }
        
        do {
            let currency = try container.decode(String.self, forKey: .currency)
            self.currency = (currency == "") ? "-" : currency
        } catch {
            self.currency = "-"
        }
        
        let date = try container.decode(Date.self, forKey: .created).formatted(date: .numeric, time: .shortened)
        self.created = (date == "1/1/2001, 3:00 AM") ? "-" : date
    }
    
}

struct TokenFromJSON: Decodable {
    var response: Token?
    var success: String
}

struct Token: Decodable {
    var token: String
}
