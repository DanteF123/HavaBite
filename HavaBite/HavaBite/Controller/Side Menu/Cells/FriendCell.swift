//
//  FriendCell.swift
//  HavaBite
//
//  Created by Dante Fusaro on 10/5/24.
//

import Foundation
import UIKit

class FriendCell: UITableViewCell{
    
    @IBOutlet weak var emailLabel: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
    }
    @IBAction func removeButtonClick(_ sender: UIButton) {
    }
}
