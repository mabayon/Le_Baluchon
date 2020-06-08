//
//  ExchangeRateViewController.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 05/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class ExchangeRatesViewController: UIViewController {

    @IBOutlet weak var fromDeviseTF: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ExchangeRatesViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
}
