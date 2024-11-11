//
//  RestaurantTableCell.swift
//  HavaBite
//
//  Created by Dante Fusaro on 10/25/24.
//

import Foundation
import UIKit

class RestaurantTableCell: UITableViewCell{
    
    @IBOutlet weak var restaurant: UILabel!

    @IBOutlet weak var restaurantDistance: UILabel!
    
    @IBOutlet weak var restaurantRating: UILabel!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
    }
    
}
