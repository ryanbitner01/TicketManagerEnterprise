//
//  OrgListTableViewCell.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/25/22.
//

import UIKit

class OrgListTableViewCell: UITableViewCell {
    
    var org: Org?
    
    static let cellIdentifier: String = "OrgListCell"

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        self.idLabel.text = org?.id
        self.nameLabel.text = org?.name
    }

}
