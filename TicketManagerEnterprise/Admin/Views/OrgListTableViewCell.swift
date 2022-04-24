//
//  OrgListTableViewCell.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/25/22.
//

import UIKit

class OrgListTableViewCell: UITableViewCell {
    
    var viewModel: OrgListCellViewModel?
    
    static let cellIdentifier: String = "OrgListCell"

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var provisionedIndicatorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        guard let viewModel = viewModel else {return}
        self.idLabel.text = "\(viewModel.orgID)"
        self.nameLabel.text = viewModel.orgName
        self.updateProvisioned(viewModel.provisioned)
    }
    
    func updateProvisioned(_ provisioned: Bool) {
        enum provisionImages: String {
            case provisioned = "checkmark.circle.fill"
            case notProvisioned = "slash.circle.fill"
        }
        
        provisionedIndicatorImageView.image = provisioned ? UIImage(systemName: provisionImages.provisioned.rawValue): UIImage(systemName: provisionImages.notProvisioned.rawValue)
    }

}
