//
//  ParentViewController.swift
//  manup
//
//  Created by iOS Development Company on 08/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit

@objc protocol RefreshProtocol: NSObjectProtocol{
    @objc optional func refreshController()
    @objc optional func refreshNotification(noti: Notification)
}

class ParentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    @IBOutlet var lblHeaderTitle: UILabel?
    @IBOutlet weak var lblFilterHeader : UILabel!
    
    var actInd:UIActivityIndicatorView!
    
    // MARK: - Actions
    @IBAction func parentBackAction(_ sender: UIButton!) {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func parentBackActionAnim(_ sender: UIButton!) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func parentDismissAction(_ sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Variables for Pull to Referesh
    let refresh = UIRefreshControl()
    var isRefereshing = false
    
    // MARK: - iOS Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constraintUpdate()
        setDefaultUI()
        kprint(items: "Allocated: \(self.classForCoder)")
    }
    
    deinit{
        _defaultCenter.removeObserver(self)
        kprint(items: "Deallocated: \(self.classForCoder)")
    }
    
    // Set Default UI
    func setDefaultUI() {
        actInd = UIActivityIndicatorView(style:.whiteLarge)
        actInd.center = view.center;
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        tableView?.scrollsToTop = true
        tableView?.tableFooterView = UIView()
    }
    
    func getNoDataCell() {
        tableView.register(UINib(nibName: "NoDataTableCell", bundle: nil), forCellReuseIdentifier: "noDataCell")
    }
    
    func getCollNoDataCell() {
        collectionView.register(UINib(nibName: "EmptyCollCell", bundle: nil), forCellWithReuseIdentifier: "noDataCell")
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    // This will update constaints and shrunk it as device screen goes lower.
    func constraintUpdate() {
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * _widthRatio
                const.constant = v2
            }
        }
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * _heightRatio
                const.constant = v2
            }
        }
    }
    
    var blurEffectView = UIView()
    func showHud() -> () {
        
        blurEffectView.frame = .init(x: 0, y: 0, width: 80, height: 80)
        blurEffectView.center = view.center
        blurEffectView.backgroundColor = UIColor(white:0, alpha:0.6)
        blurEffectView.layer.cornerRadius = 5
        self.blurEffectView.alpha = 1
        view.addSubview(blurEffectView)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        blurEffectView.addSubview(actInd)
        actInd.frame.origin = CGPoint(x:(blurEffectView.frame.width / 2) - (actInd.frame.width / 2) , y: (blurEffectView.frame.height / 2) - (actInd.frame.height / 2))
        actInd.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideHud() -> (){
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            UIView.animate(withDuration:0.2, animations: {
                self.blurEffectView.alpha = 0
            }, completion: { (done) in
                self.actInd.stopAnimating()
                self.blurEffectView.removeFromSuperview()
            })
            self.view.isUserInteractionEnabled = true
        }
    }
    
}

extension ParentViewController{
    
    func setKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height + 10, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    }
}


//MARK:- Uitility Methods
extension ParentViewController {
    
    func tableViewCell(index: Int , section : Int = 0) -> UITableViewCell {
        let cell = tableView.cellForRow(at: NSIndexPath(row: index, section: section) as IndexPath)
        return cell!
    }
    
    func scrollToIndex(index: Int, animate: Bool = false){
        if index >= 0{
            let indexPath = NSIndexPath(row: index, section: 0)
            tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.none, animated: animate)
        }
    }
    
    func scrollToIndexChat(section: Int, index: Int, animate: Bool = false){
        if index >= 0{
            let indexPath = NSIndexPath(row: index, section: section)
            tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: animate)
        }
    }
    
    func scrollToTop(animate: Bool = false) {
        let point = CGPoint(x: 0, y: -tableView.contentInset.top)
        tableView.setContentOffset(point, animated: animate)
    }
    
    func scrollToBottom(animate: Bool = false)  {
        let point = CGPoint(x: 0, y: tableView.contentSize.height + tableView.contentInset.bottom - tableView.frame.height)
        if point.y >= 0{
            tableView.setContentOffset(point, animated: animate)
        }
    }
    
    func customPresentationTransition() {
        let transition = CATransition()
        transition.duration = _vcTransitionTime
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        view.window?.layer.add(transition, forKey: kCATransition)
    }
}

//MARK: - TableView
extension ParentViewController{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

// MARK: - Validation Message.
extension ParentViewController {
    
    // Show API Error
    /// Desc
    ///
    /// - Parameters:
    ///   - data: json object
    ///   - yPos: Banner possition
    func showError(data: Any?, view: UIView?) {
        hideHud()
        refresh.endRefreshing()
        if let dict = data as? NSDictionary{
            if let msg = dict["message"] as? String{
                JTValidationToast.show(message: msg, viewController: self, type: .error, presentType: .top, animationStlye: .slide, completion: nil)
            } else if let msg = dict["code"] as? String{
                JTValidationToast.show(message: msg, viewController: self, type: .error, presentType: .top, animationStlye: .slide, completion: nil)
            } else{
                JTValidationToast.show(message: kInternalError, viewController: self, type: .error, presentType: .top, animationStlye: .slide, completion: nil)
            }
        }else{
            JTValidationToast.show(message: kInternalError, viewController: self, type: .error, presentType: .top, animationStlye: .slide, completion: nil)
        }
    }
    
    func showSuccMsg(dict: NSDictionary, completion: (() -> ())? = nil) {
        JTValidationToast.show(message: dict.getStringValue(key: "message"), viewController: self, type: .success, presentType: .top, animationStlye: .slide, completion: completion)
    }
    
    func showSuccessMsg(data: Any?, view: UIView?) {
        if let dict = data as? NSDictionary{
            if let msg = dict["Message"] as? String{
                JTValidationToast.show(message: msg, viewController: self, type: .success, presentType: .top, animationStlye: .slide, completion: nil)
            }else if let msg = dict["Result"] as? String{
                JTValidationToast.show(message: msg, viewController: self, type: .success, presentType: .top, animationStlye: .slide, completion: nil)
            }
        }
    }
    func showError(msg: String) {
        _ = JTValidationToast.show(message: msg, viewController: self, type: .error)
    }
}

//MARK: - Custom SlideMenu
extension ParentViewController {
    
    @IBAction func shutterAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        if let containerController = self.findContainerController(){
            containerController.animatedDrawerEffect()
        }
    }
    
    
    func findContainerController() -> SideMenuContainerVC? {
        
        let navCon = _appDelegator.window!.rootViewController as! UINavigationController
        for vc in navCon.viewControllers {
            if let con = vc as? SideMenuContainerVC {
                return con
            }
        }
        return nil
    }
}
