//
//  OtpVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/7/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseMessaging
import Reachability


class OtpEmailVC: ParentViewController {
    
    @IBOutlet weak var tfInput : UITextField!
    @IBOutlet var lbls :[UILabel]!
    @IBOutlet var views : [UIView]!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnResendView : UIView!
    let reach = try! Reachability()
    var toolBar: ToolBarView!
    var timer: Timer?
    var strEmail = ""
    var strOTPCode = ""
    var strCode = ""
    var seconds = 30
    var verificationID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reachabilityCheck()
    }
    
    override func becomeFirstResponder() -> Bool {
        tfInput.becomeFirstResponder()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tfInput.becomeFirstResponder()
    }
    
    deinit {
        reach.stopNotifier()
    }
}

//MARK:- Others Methods
extension OtpEmailVC{
    func prepareUI(){
        btnResendView.isHidden = true
        tfInput.textContentType = .oneTimeCode
        if let fcmtoken = Messaging.messaging().fcmToken {
            _appDelegator.storeFCMToken(token: fcmtoken)
        }
    }
    
    func initTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds == 0 {
            timer?.invalidate()
            btnResendView.isHidden = !btnResendView.isHidden
            setCodeUI()
        } else {
            seconds -= 1
            lblTimer.text = "0:\(seconds)"
        }
    }
    
    func prepareToolbar(){
        toolBar = ToolBarView.instantiateViewFromNib()
        toolBar.handleTappedAction { [weak self] (tapped, toolbar) in
            self?.view.endEditing(true)
        }
        tfInput.inputAccessoryView = toolBar
    }
    
    func setCodeUI()  {
        for lbl in lbls{
            lbl.text = ""
        }
        for vw in views {
            vw.alpha = 0.4
        }
        for (idx,chr) in strCode.enumerated(){
            lbls[idx].text = String(chr)
            views[idx].backgroundColor = .black
            views[idx].alpha = 1.0
        }
    }
    
    func reachabilityCheck(){
        DispatchQueue.main.async {
            self.reach.whenUnreachable = {_ in
                noInternetPage(mainVc: self, nav: self.navigationController!)
            }
            do{
                try self.reach.startNotifier()
            }catch{
                print("Not start Notifier")
            }
        }
    }
}


extension OtpEmailVC{
    @IBAction func tfInputTapped(_ sender: UIButton){
        tfInput.becomeFirstResponder()
    }
    
    @IBAction func btnResendTapped(_ sender: UIButton){
        btnResendView.isHidden = !btnResendView.isHidden
        seconds = 30
        strCode = ""
        setCodeUI()
        initTimer()
        loginUserEmail()
    }
}


//MARK:- TextField Delegate Methods
extension OtpEmailVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = textField.text! + string
        if str.count > 6 {
            return false
        }
        let cs = NSCharacterSet(charactersIn: "0123456789").inverted
        let filStr = string.components(separatedBy: cs).joined(separator: "")
        return string == filStr
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

//MARK:- OTP Verification Methods
extension OtpEmailVC{
    
    @IBAction func tfInputChanged(_ textField: UITextField){
        strCode = textField.text!.trimWhiteSpace()
        setCodeUI()
        if strCode.count == 6 {
            tfInput.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.verifyOTPCode()
            }
        }
    }
    
    func verifyOTPCode(){
        showHud()
        if strOTPCode == strCode {
            self.loginUser()
        } else {
            self.showError(msg: "Please enter valid OTP")
        }
    }
    
    func navigateToProfile() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier :"EditProfileVC") as! EditProfileVC        
        vc.email = ""
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- WebCall Methods
extension OtpEmailVC{
    func loginUser(){
        showHud()
        let param : [String : Any] = ["email":strEmail,"otp":strCode]
        KPWebCall.call.OTPEmailUser(param: param) { [weak self](json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode == 200, let dict = json as? NSDictionary{
                if let isSuccess = dict["success"] as? Bool,isSuccess{
                    if let res = dict["result"] as? NSDictionary{
                        let token = res.getStringValue(key: "token")
                        _appDelegator.storeAuthorizationToken(strToken: token)
                        _user = Users.addUpdateEntity(key: "id", value: res.getStringValue(key: "id"))
                        _user.initWith(dict: res)
                        _appDelegator.saveContext()
                        weakSelf.showSuccMsg(dict: dict) {
                            if _user.role == "3"{
                                _appDelegator.navigateUserToHome()
                            }else{
                                weakSelf.showError(msg: "You can't Login with Barber Mobile Number")
                                weakSelf.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }else{
                    weakSelf.navigateToProfile()
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
    
    func loginUserEmail()  {
        showHud()
        let param : [String : Any] = ["email" : strEmail]
        KPWebCall.call.loginEmailUser(param: param) { [weak self](json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode == 200, let dict = json as? NSDictionary{
                if let isSuccess = dict["success"] as? Bool,isSuccess{
                    if let res = dict["result"] as? NSDictionary{
                        weakSelf.strOTPCode = res.getStringValue(key: "otp")
                        weakSelf.strOTPCode = res.getStringValue(key: "otp")
                    }
                }else{
                    // weakSelf.navigateToProfile()
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
