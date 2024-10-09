//
//  FriendCell.swift
//  HavaBite
//
//  Created by Dante Fusaro on 10/5/24.
//

import Foundation
import UIKit

protocol FriendCellDelegate: AnyObject {
    func didTapRemoveButton(on cell: FriendCell)
}

class FriendCell: UITableViewCell{
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var userEmail: UILabel!
    
    weak var delegate: FriendCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
    }
    @IBAction func removeButtonClick(_ sender: UIButton) {
        delegate?.didTapRemoveButton(on: self)
    }
    
}
