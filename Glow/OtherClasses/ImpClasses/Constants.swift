import UIKit
import Foundation
import CoreLocation
import Reachability

/*---------------------------------------------------
 Screen Size
 ---------------------------------------------------*/
let _screenSize     = UIScreen.main.bounds.size
let _screenFrame    = UIScreen.main.bounds

/*---------------------------------------------------
 Constants
 ---------------------------------------------------*/
let _defaultCenter  = NotificationCenter.default
let _userDefault    = UserDefaults.standard
let _appDelegator   = UIApplication.shared.delegate! as! AppDelegate
let _application    = UIApplication.shared



/*---------------------------------------------------
 Facebook
 ---------------------------------------------------*/
let _facebookPermission              = ["public_profile", "email", "user_friends"]
let _facebookMeUrl                   = "me"
let _facebookAlbumUrl                = "me/albums"
let _facebookUserField: [String:Any] = ["fields" : "id,first_name,last_name,gender,birthday,email,education,work,picture.height(700)"]
let _facebookJobSchoolField          = ["fields" : "education,work"]
let _facebookAlbumField              = ["fields":"id,name,count,picture"]
let _facebookPhotoField              = ["fields":"id,picture"]

/*---------------------------------------------------
 Privacy and Terms URL
 ---------------------------------------------------*/
let _aboutUsUrl        = "https://www.google.com"
let _privacyUrl        = "https://www.google.com"
let _helpUrl           = "https://www.google.com"
let _termsUrl          = "https://www.google.com"
let _multipzUrl        = "http://multipz.com/about-us"

/*---------------------------------------------------
 MARK: Paging Structure
 ---------------------------------------------------*/
struct LoadMore{
    var index: Int = 0
    var isLoading: Bool = false
    var limit: Int = 20
    var isAllLoaded = false
    
    var offset: Int{
        return index * limit
    }
}

/*--------------------------------------------------
 Stripe
 ---------------------------------------------------*/
let stripeTestKey = "pk_test_51It9EjSHK7KhWYBoxSQEsoOYBu5Kxd2mGMKiCl3CcxKEaLpPhCTvRKEbH1POhGSpg40nOZz7xl0EBgAbDqEcwnA000hdsxqQSu"
/*---------------------------------------------------
 Current loggedIn User
 ---------------------------------------------------*/
let _deviceType = "ios"
let _deviceId = UIDevice.current.identifierForVendor!.uuidString

/*---------------------------------------------------
 Date Formatter and number formatter
 ---------------------------------------------------*/
let _serverFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    df.locale = Locale(identifier: "en_US_POSIX")
    return df
}()

let _deviceFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeZone = TimeZone.current
    df.dateFormat = "yyyy-MM-dd"
    return df
}()

let _numberFormatter:NumberFormatter = {
    let format = NumberFormatter()
    format.locale = Locale(identifier: "en_IN")
    format.numberStyle = .currency
    format.allowsFloats = true
    format.minimumFractionDigits = 2
    format.maximumFractionDigits = 2
    return format
}()

/*---------------------------------------------------
 Place Holder image
 ---------------------------------------------------*/
let _placeImage = UIImage(named: "ic_placeholder")
let _placeImageUser = UIImage(named: "ic_profilePic")

let googleApiKey = "AIzaSyCvFFGw2nEskis5IywbFlWEgSITCdfc9dg"

let kActivityButtonImageName = ""
let kActivitySmallImageName = ""

/*---------------------------------------------------
 User Default and Notification keys
 ---------------------------------------------------*/
let FadeAuthTokenKey         = "FadeAuthTokenKey"
let FadeFCMTokenKey         = "FadeFCMTokenKey"
let FadeOnboardigKey         = "FadeOnboardigKey"
let FadeEmailLoginKey         = "FadeOnboardigKey"
let FadeWelcomeKey         = "FadeWelcomeKey"
let FadeAppUpdateKey         = "FadeAppUpdateKey"
var updateLatitutde = 0.0
var updateLongitude = 0.0

struct Pagination{
    var isDataLoading: Bool = false
    var pageNo: Int = 1
    var limit: Int = 20
    var didEndReached: Bool = false
    var offset : Int = 0
}

/*---------------------------------------------------
 Custom print
 ---------------------------------------------------*/
func kprint(items: Any...) {
    #if DEBUG
    for item in items {
        print(item)
    }
    #endif
}

/*---------------------------------------------------
 Settings Version Maintenance
 ---------------------------------------------------*/
func getAppVersionAndBuild() -> String{
    if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
        return "Version - \(version)(\(build))"
    }else{
        return ""
    }
}

func getAppversion() -> String{
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
        return version
    }else{
        return ""
    }
}

func setAppSettingsBundleInformation(){
    if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
        _userDefault.set(build, forKey: "application_build")
        _userDefault.set(version, forKey: "application_version")
        _userDefault.synchronize()
    }
}

/*---------------------------------------------------
 Device Extention
 ---------------------------------------------------*/
extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    class func isiPhone4() -> Bool {
        return _screenSize.height == 480.0 && UIDevice.current.userInterfaceIdiom == .phone
    }
}

//MARK:- Constant
//-------------------------------------------------------------------------------------------
// Common
//-------------------------------------------------------------------------------------------
let _statusBarHeight           : CGFloat = _appDelegator.window!.rootViewController!.topLayoutGuide.length
let _navigationHeight          : CGFloat = _statusBarHeight + 44
let _btmNavigationHeight       : CGFloat = _bottomAreaSpacing + 64
let _btmNavigationHeightSearch : CGFloat = _bottomAreaSpacing + 64 + 45
let _bottomAreaSpacing         : CGFloat = _appDelegator.window!.rootViewController!.bottomLayoutGuide.length
let _vcTransitionTime                    = 0.3
let _tabBarHeight              : CGFloat = 65 + _bottomAreaSpacing
let _imageFadeTransitionTime   : Double  = 0.3
var _user : Users!
var strCurrentLocation :String = "Current Location"
/*---------------------------------------------------
 Date Formatter and number formatter
 ---------------------------------------------------*/

let _timeFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
    return dateFormatter
}()

func noInternetPage(mainVc : UIViewController, nav: UINavigationController){
    let storyboard = UIStoryboard(name: "Entry", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier :"NoInternetVC") as! NoInternetVC

    vc.nav = nav
    vc.modalPresentationStyle = .fullScreen
    mainVc.navigationController?.present(vc, animated: true, completion: nil)
}
