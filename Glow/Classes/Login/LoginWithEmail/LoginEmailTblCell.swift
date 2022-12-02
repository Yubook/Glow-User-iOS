//
//  LoginTblCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/8/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class LoginEmailTblCell: UITableViewCell {
    @IBOutlet weak var tfInput : UITextField!
    
    weak var parentVC : LoginEmailVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func prepareCell(data : LoginEmailModel, index: Int){
        switch data.cellType{
        case .txtEmailFieldCell:
            tfInput.placeholder = data.placeHolderTitle
            tfInput.keyboardType = data.keyboardType
            tfInput.keyboardAppearance = data.keyboardAppearance
            tfInput.text = data.value
            tfInput.tag = index
        default: break
        }
    }
}

//MARK:- TextField Action Methods
extension LoginEmailTblCell : UITextFieldDelegate{
    @IBAction func tfInputDidChange(_ textField: UITextField){
        if let str = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            self.parentVC.objModel.arrData[textField.tag].value = str
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
