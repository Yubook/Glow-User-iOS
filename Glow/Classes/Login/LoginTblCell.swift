//
//  LoginTblCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/8/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class LoginTblCell: UITableViewCell {
    @IBOutlet weak var tfInput : UITextField!
    
    weak var parentVC : LoginVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func prepareMobileCell(data : LoginModel, index: Int){
        switch data.cellType{
        case .txtFieldCell:
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
extension LoginTblCell : UITextFieldDelegate{
    @IBAction func tfInputDidChange(_ textField: UITextField){
        if let str = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            self.parentVC.objModel.arrData[textField.tag].value = str
            if str.count == 10 {
                textField.resignFirstResponder()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = textField.text! + string
        if str.count > 10 {
            return false
        }
        let cs = NSCharacterSet(charactersIn: "0123456789").inverted
        let filStr = string.components(separatedBy: cs).joined(separator: "")
        return string == filStr
    }
}
