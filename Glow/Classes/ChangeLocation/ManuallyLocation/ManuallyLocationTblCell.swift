//
//  ManuallyLocationTblCell.swift
//  Fade
//
//  Created by Chirag Patel on 29/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class ManuallyLocationTblCell: UITableViewCell {
    @IBOutlet weak var lblSectionTitle : UILabel!
    @IBOutlet weak var tfInput : UITextField!
    
    weak var parentVC : ManuallyLocationVC!
    
    func prepareCell(data: ManuallyLocModel,index: Int){
        switch data.cellType{
        case .textFieldCell:
            tfInput.text = data.value
            tfInput.keyboardType = data.keyBoardType
            tfInput.returnKeyType = data.returnKeyType
            tfInput.tag = index
            self.lblSectionTitle.text = data.sectionTitle
        }
    }
}

//MARK:- TextField EditingChanged Methods
extension ManuallyLocationTblCell{
    @IBAction func tfInputEditingChanged(_ textField: UITextField){
        if let str = tfInput.text?.trimmingCharacters(in: .illegalCharacters){
            parentVC.objData.arrData[textField.tag].value = str
        }
    }
}
