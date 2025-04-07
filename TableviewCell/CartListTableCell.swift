//
//  CartListTableCell.swift
//  FakeStoreApp
//
//  Created by Gaurav Agnihotri on 07/04/25.
//

import UIKit

class CartListTableCell: UITableViewCell {

    @IBOutlet weak var btn_minus: RoundedButton!
    @IBOutlet weak var btn_plus: RoundedButton!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_item: UIImageView!
    @IBOutlet weak var view_item: UIView!
    @IBOutlet weak var btn_select: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        btn_minus.cornerRadius = btn_minus.layer.frame.height/2
        btn_minus.clipsToBounds = true
        btn_plus.cornerRadius = btn_plus.layer.frame.height/2
        btn_plus.clipsToBounds = true
        // Configure the view for the selected state
    }

}
