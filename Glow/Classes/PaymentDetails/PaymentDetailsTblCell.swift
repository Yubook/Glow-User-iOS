//
//  PaymentDetailsTblCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 5/12/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class PaymentDetailsTblCell: UITableViewCell {
    @IBOutlet weak var tfInput : UITextField!
    @IBOutlet weak var tfInput1 : UITextField!
    @IBOutlet weak var imgCheckBox : UIImageView!
    @IBOutlet weak var lblWalletBalance : UILabel!
    @IBOutlet weak var imgCheck : UIImageView!
    @IBOutlet weak var lblBalance : UILabel!
    
    weak var parentVC : PaymentDetailsVC!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func perpareCell(data: PaymentDetailsModel, idx: Int){
        switch data.cellType{
        case .txtCardCell:
            tfInput.tag = idx
            tfInput.placeholder = data.placeholderName
            tfInput.keyboardType = data.keyBoardType
            tfInput.returnKeyType = data.keyReturnType
            tfInput.text = data.value
            
        case .doubleTextField:
            //1
            tfInput.tag = idx
            tfInput.placeholder = data.placeholderName
            tfInput.autocorrectionType = .no
            tfInput.autocapitalizationType = data.keyBoardType == .emailAddress ? .none : .words
            tfInput.keyboardType = data.keyBoardType
            tfInput.returnKeyType = data.keyReturnType
            tfInput.text = data.value
            tfInput.text =  data.value2
            
            //2
            tfInput1.tag = idx
            tfInput1.placeholder = data.placeHolderOne
            tfInput1.autocorrectionType = .no
            tfInput1.autocapitalizationType = .words
            tfInput1.keyboardType = data.keyBoardType
            tfInput1.returnKeyType = data.keyReturnType
            tfInput1.text = data.str
        default:
            break
        }
    }
}

//MARK:- TextField Editing Change Methods
extension PaymentDetailsTblCell{
    @IBAction func tfEditingChanged(_ textField : UITextField){
        if textField.tag == 1{
            let str = textField.text!.trimmedString()
            parentVC.objData.arrData[textField.tag].value = str
        }else if textField.tag == 2{
            let str = textField.text!.applyPatternOnNumbers(pattern: "#### #### #### ####")
            parentVC.objData.arrData[textField.tag].value = str
            if str.count == 19 {
                if let cell = parentVC.getCardCell(row: textField.tag + 1, section: 0) {
                    cell.tfInput.becomeFirstResponder()
                }
            }
            tfInput.text = parentVC.objData.arrData[textField.tag].value
        }else if textField.tag == 3{
            if textField == tfInput {
                let str = textField.text!.applyPatternOnNumbers(pattern: "##/##")
                
                
                let split = str.components(separatedBy: "/")
                let month = split.first!
                let year = split.last!
                parentVC.objData.arrData[textField.tag].value = month
                parentVC.objData.arrData[textField.tag].value2 = year
                
                tfInput.text = str
                
                if str.count == 5 {
                    tfInput1.becomeFirstResponder()
                }
            } else {
                let str1 = textField.text!.applyPatternOnNumbers(pattern: "###")
                parentVC.objData.arrData[textField.tag].str = str1
                tfInput1.text = parentVC.objData.arrData[textField.tag].str
                if str1.count == 3 {
                    tfInput1.resignFirstResponder()
                }
            }
        }
    }
}
