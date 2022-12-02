//
//  ReviewListVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class ReviewListVC: ParentViewController {
    
    var arrReviews : [Reviews] = []
    var loadMore = LoadMore()
    var driverId : String = ""
    var arrImgLists : [ImageList] = []
    var arrFilter : [Reviews]{
        return arrReviews.filter{$0.toId == driverId}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

//MARK:- Others Methods
extension ReviewListVC{
    func prepareUI(){
        self.getReviews()
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 150.0;
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 15, right: 0)
    }
}


//MARK:- TableView Delegate & DataSource Methods
extension ReviewListVC{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return arrFilter.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ReviewListTblCell
        
        if indexPath.section == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "totalReviewCell", for: indexPath) as! ReviewListTblCell
            cell.lblTotalReviews.text = "\(arrFilter.count)"
            return cell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "reviewListCell", for: indexPath) as! ReviewListTblCell
            cell.parent = self
            cell.prepareCell(data: arrFilter[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ?  45.widthRatio :  200.widthRatio
    }
}

//MARK:- Reviews WebCall Methods
extension ReviewListVC{
    func pramDict() -> [String : Any]{
        var dict : [String : Any] = [:]
        dict["limit"] = loadMore.limit
        return dict
    }
    
    
    func getReviews(){
        if !refresh.isRefreshing && loadMore.index == 0 {
            showHud()
        }
        loadMore.isLoading = true
        KPWebCall.call.getReview(param: pramDict()) { [weak self](json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            weakSelf.refresh.endRefreshing()
            weakSelf.loadMore.isLoading = false
            weakSelf.arrReviews = []
            if statusCode == 200, let dict = json as? NSDictionary, let result = dict["result"] as? [NSDictionary]{
                weakSelf.showSuccMsg(dict: dict)
                if weakSelf.loadMore.index == 0{
                    weakSelf.arrReviews = []
                }
                for data in result{
                    let objData = Reviews(dict: data)
                    weakSelf.arrReviews.append(objData)
                }
                if result.isEmpty{
                    weakSelf.loadMore.isAllLoaded = true
                }else{
                    weakSelf.loadMore.index += 1
                }
                DispatchQueue.main.async {
                    weakSelf.tableView.reloadData()
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
    
    func getImages() -> [ImageList]{
        var imgs : [ImageList] = []
        for data in arrFilter{
            imgs = data.arrimgList
        }
        return imgs
    }
}

//MARK:- ZoomImage Methods
extension ReviewListVC{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "zoom"{
            let vc = segue.destination as! ZoomImageVC
            if let url = sender as? URL{
                vc.arrUrls.append(url)
            }
        }
    }
}

