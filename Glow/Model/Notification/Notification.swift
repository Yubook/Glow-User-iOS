//
//  Notification.swift
//  Fade
//
//  Created by Devang Lakhani  on 6/29/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

class NotificationList{
    var id : String
    var orderId : String
    var userId : String
    var title : String
    var message : String
    var orderStatus : String
    var isRead : Bool
    var updateDate : Date?
    
    var strTime : String{
        let time = Date.localDateString(from: updateDate, format: "d MMM,yyyy h:mm a")
        return time
    }
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        orderId = dict.getStringValue(key: "order_id")
        userId = dict.getStringValue(key: "user_id")
        title = dict.getStringValue(key: "title")
        message = dict.getStringValue(key: "message")
        orderStatus = dict.getStringValue(key: "order_status")
        isRead = dict.getBooleanValue(key: "is_read")
        updateDate = Date.dateFromServerFormat(from: dict.getStringValue(key: "created_at"))
    }
}
