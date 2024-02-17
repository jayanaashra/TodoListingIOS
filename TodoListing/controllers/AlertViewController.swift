//
//  AlertViewController.swift
//  TodoListing
//
//  Created by Jayana Soneji on 17/02/67 BE.
//  Copyright © 2567 BE App Brewery. All rights reserved.
//

import UIKit

protocol AlertControllerDelegate: AnyObject {
    func onAlertAddAction(textField: UITextField)
    
}

class AlertViewController: UIViewController {
    var alertTitle: String?
    var alertStyle: UIAlertController.Style
    var alert: UIAlertController
    var buttonText: String
    weak var delegate: AlertControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    init(alertTitle: String?, alertStyle: UIAlertController.Style, buttonText: String) {
        self.alertTitle = alertTitle
        self.alertStyle = alertStyle
        self.buttonText = buttonText
        
        self.alert = UIAlertController(title: alertTitle, message: "", preferredStyle: alertStyle)
        
        super.init(nibName: "AlertViewController", bundle: Bundle(for: AlertViewController.self) )
        self.createAlert()
        
    }
    
    
    
    required public init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
    
    func createAlert() {
        var textField = UITextField()
        
        let action = UIAlertAction(title: buttonText, style: .default){(action) in

            self.delegate?.onAlertAddAction(textField: textField)
            
        }
        let cancelaction = UIAlertAction(title: "Cancel", style: .default){(action) in
            
        }
        
        action.isEnabled = false
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "write..."
            
            alertTextField.addTarget(self, action: #selector(self.alertTextFieldDidChanged(_:)), for: .editingChanged)
            textField =  alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelaction)
    }
    
    func showAlert() {
        alert.textFields![0].text = ""
        alert.actions[0].isEnabled = false
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func alertTextFieldDidChanged(_ sender: UITextField) {
        alert.actions[0].isEnabled = sender.text!.count > 0
    }

  

}
