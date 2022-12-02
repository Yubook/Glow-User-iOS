//
//  EditProfileTblCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/14/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class EditProfileTblCell: UITableViewCell {
    @IBOutlet weak var tfInput: UITextField!
    @IBOutlet weak var imgRightView : UIImageView!
    @IBOutlet weak var tfPhoneInput : UITextField!
    @IBOutlet weak var tfLocationInput : UITextField!
    
    weak var parentVC : EditProfileVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func prepareCell(data: EditProfileModel, index: Int){
        switch data.cellType{
        case .textFieldCell :
            tfInput.placeholder = data.placeHolderTitle
            tfInput.keyboardType = data.keyboardType
            tfInput.returnKeyType = data.returnKeyType
            imgRightView.image = data.img
            tfInput.text = data.value
            tfInput.tag = index
            prepareTextField(txtField: tfInput)
            
        case .phoneCell:
            tfPhoneInput.text = data.value
            tfPhoneInput.tag = index
            tfPhoneInput.keyboardType = data.keyboardType

        case .locationCell:
            tfLocationInput.isUserInteractionEnabled = false
            prepareTextField(txtField: tfLocationInput)
        default : break
        }
    }
    
    func prepareTextField(txtField : UITextField){
        txtField.layer.cornerRadius = 12
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = #colorLiteral(red: 0.1333333333, green: 0.137254902, blue: 0.1529411765, alpha: 1)
    }
    
    func disableText(data: EditProfileModel, index: Int){
        if data.cellType == .textFieldCell && index == 1{
            tfInput.isUserInteractionEnabled = false
            tfInput.alpha = 0.5
        }
    }
}


//MARK:- TextField Delegate and Action Methods
extension EditProfileTblCell : UITextFieldDelegate{
    @IBAction func tfInputDidchange(_ textField: UITextField){
        if let str = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            self.parentVC.objModel.arrEditProfileData[textField.tag].value = str
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .phonePad {
            let str = textField.text! + string
            if str.count > 10 {
                return false
            }
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filStr = string.components(separatedBy: cs).joined(separator: "")
            return string == filStr
        }
        return true
    }
}
