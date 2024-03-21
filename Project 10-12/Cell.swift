//
//  Cell.swift
//  Project 10-12
//
//  Created by Dmitrii Vrabie on 27.02.2024.
//

import UIKit

class Cell: UITableViewCell {
    @IBOutlet var imageRow: UIImageView!
    @IBOutlet var textLabelRow: UILabel!
    
    var buttonClick : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabelRow.isUserInteractionEnabled = true
        
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
        textLabelRow.addGestureRecognizer(guestureRecognizer)
        
    }
    @objc func labelClicked(_ sender: Any) {
        print("UILabel clicked")
        
        if let action = buttonClick {
              action()
          }
    }
}
