//
//  UserDataTableCell.swift
//  Day2
//
//  Created by P090MMCTSE016 on 19/10/23.
//

import UIKit

class UserDataTableCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblSalary: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setValue(user: UserModel){
        lblName.text = "\(user.id), \(user.name)"
        lblSalary.text = "IDR \(user.salary)"
    }
    
}
