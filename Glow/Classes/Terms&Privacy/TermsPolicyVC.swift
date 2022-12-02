//
//  TermsPolicyVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 6/30/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import WebKit

class TermsPolicyVC: ParentViewController {
    
    @IBOutlet weak var webView : WKWebView!
    
    var arrData : [TermsPolicy] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getTermsPolicy()
    }
    
    func loadWebView(){
        for data in arrData{
            if data.selection == "Terms"{
                webView.loadHTMLString(data.description, baseURL: nil)
            }
        }
    }
}


//MARK:- Terms & Policy WebCall Method
extension TermsPolicyVC{
    func getTermsPolicy(){
        showHud()
        KPWebCall.call .getTermsPolicy(param: ["for" : "3"]) {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode == 200, let dict = json as? NSDictionary{
                if let dictResult = dict["result"] as? [NSDictionary]{
                    for dictData in dictResult{
                        let terms = TermsPolicy(dict: dictData)
                        weakSelf.arrData.append(terms)
                    }
                    weakSelf.loadWebView()
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
