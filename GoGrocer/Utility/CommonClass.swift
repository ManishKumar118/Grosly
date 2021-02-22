
import UIKit
import Foundation
import CoreImage
import SystemConfiguration

//********************* Get App Version *********************
func getAppVersion() -> String {
    let dictionary = Bundle.main.infoDictionary!
    let version = dictionary["CFBundleShortVersionString"] as! String
    // let build = dictionary["CFBundleVersion"] as! String
    return "\(version)"
}

//********************* Get Scale Factor ********************
func getScaleFactor() -> CGFloat {
    let screenRect:CGRect = UIScreen.main.bounds
    let screenWidth:CGFloat = screenRect.size.width
    let scalefactor:CGFloat!
    scalefactor = screenWidth / 375.0
    return scalefactor
}

//********************* isValidEmail ***********************
func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

//******************* Show Notification Alert ****************
func showNotifificationAlert(_ text: String, bgColor: UIColor, textColor: UIColor) {
    let l = UILabel()
    l.textColor = textColor
    l.backgroundColor = bgColor
    l.font = UIFont(name: "Poppins-Regular" , size:14)
    l.text = text
    l.textAlignment = .center
    l.numberOfLines = 0
    if let window :UIWindow = UIApplication.shared.keyWindow {
        l.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 64)
        window.addSubview(l)
    }
    l.center.y -= 50
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
        
        l.center.y += 50
        
    }, completion: {_ in
        
        UIView.animate(withDuration: 0.5, animations: {
            l.center.y -= 40
        }, completion: { (_) in
            l.removeFromSuperview()
            
        })
    })
}


//************************ Save image at Document Directory *****************************

func saveImageDocumentDirectory(_ image:UIImage, imageName name : String){
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
    print(paths)
    let imageData = image.jpegData(compressionQuality: 0.8)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}

func getDirectoryPath(_ name : String) -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return "\(documentsDirectory)/\(name)"
}





//MARK:- *************************** HIDE/SHOW Rating View ************************************************








//************************ Open Google Map *************************************************

func openGoogleMap(_ lat:String, longitude lng:String)
{
    let latitude = lat.replacingOccurrences(of: " ", with: "")
    let longitude = lng.replacingOccurrences(of: " ", with: "")
    
    //saddr is blank to show route from My Current Location on Google map
    if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
        UIApplication.shared.open(URL.init(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")!, options:  [:], completionHandler: nil)
    } else {
        UIApplication.shared.open(URL.init(string: "http://maps.google.com/?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")!, options:  [:], completionHandler: nil)
        NSLog("Can't use comgooglemaps://");
    }
}

// ***************************** Call to Phone *****************************************************

func callToPhone(_ phoneNumber: String) {
    // I add this line to make sure passed number wihthout space
    let CleanphoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
    if let phoneCallURL = URL.init(string: "telprompt://\(CleanphoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            UIApplication.shared.open(phoneCallURL, options:  [:], completionHandler: nil)
        }
    }
}
 func callNumber(phoneNumber:String) {
    
    
    
    
   if let url = URL(string: "tel://\(phoneNumber)") {
        
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(url)) {
            if #available(iOS 10.0, *) {
                application.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                application.openURL(url as URL)
                
            }
        }
    }
}

// *************************** Set pin on Google Map ************************************************

//////////////////Marker Pin Custom Design//////////////////////////
func drawText(_ text: String, inImage image: UIImage, TextColor textColor: UIColor) -> UIImage {
    
    let font = UIFont.boldSystemFont(ofSize: 11)
    let size = image.size
    print(size)
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    image.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
    let rect = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
    print(rect)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = NSTextAlignment.center
    let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: textColor]
    let textSize = text.size(withAttributes: attributes)
    let textRect = CGRect.init(x: ((rect.size.width - textSize.width) / 2 - 5), y: (rect.size.height - textSize.height) / 2 - 4, width: textSize.width, height: textSize.height)
    text.draw(in: textRect.integral, withAttributes: attributes)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}


// **************************** Show alert **************************************

func alert  (message: String,title: String) {
    let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle:nil, otherButtonTitles: "OK")
    alertView.alertViewStyle = .default
    alertView.show()
}

func showAlert(_ title: String?, message: String, withAction addAction:UIAlertAction?, isCancel cancel:Bool, sender:UIViewController) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title:"OK", style: UIAlertAction.Style.cancel) {
        UIAlertAction in
        NSLog("Cancel Pressed")
    }
    // Add the actions
    if cancel == true {
        alertController.addAction(cancelAction)
    }
    
    if let action = addAction {
        alertController.addAction(action)
    }
    
    // Present the controller
    sender.present(alertController, animated: true, completion: nil)
}

//******************* Key exists or not in UserDefault ************************
func isKeyExists(key:String) ->Bool {
    if (UserDefaults.standard.object(forKey: key) != nil) {
        return true
    }else {
        return false
    }
}

//******************* SAVE OBJECT DICTONARY IN USER DEFAULT *******************
func saveObjectDict(key:String, objArray:[String:Any]){
    let data =  NSKeyedArchiver.archivedData(withRootObject: objArray);
    UserDefaults.standard.set(data, forKey: key)
    UserDefaults.standard.synchronize();
}

//******************* FETCH OBJECT DICTIONARY FROM USER DEFAULT *******************
func fetchObjectDict(key:String)->[String:Any] {
    var objArray:[String:Any]=[String:Any]();
    if let data = UserDefaults.standard.object(forKey: key) as? NSData {
        objArray = (NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [String:Any])!
    }
    return objArray;
}

//******************* REMOVE NSUSER DEFAULT *******************
func removeUserDefault(key:String) {
    UserDefaults.standard.removeObject(forKey: key);
}

//******************* SAVE STRING IN USER DEFAULT *******************
func saveStringInDefault(value:Any,key:String) {
    UserDefaults.standard.setValue(value, forKey: key);
    UserDefaults.standard.synchronize();
}

//******************* FETCH STRING FROM USER DEFAULT *******************
func fetchString(key:String)->AnyObject {
    if (UserDefaults.standard.object(forKey: key) != nil) {
        return UserDefaults.standard.value(forKey: key)! as AnyObject;
    }else {
        return "" as AnyObject;
    }
}

// ******************** Blurr Image ****************
func makeImageBlurr(_ image : UIImage) -> (UIImage) {
    let context = CIContext(options: nil)
    var blurredImage = image
    let currentFilter = CIFilter(name: "CIGaussianBlur")
    let beginImage = CIImage(image: blurredImage)
    currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
    currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
    
    let cropFilter = CIFilter(name: "CICrop")
    cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
    cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
    
    let output = cropFilter!.outputImage
    let cgimg = context.createCGImage(output!, from: output!.extent)
    let processedImage = UIImage(cgImage: cgimg!)
    blurredImage = processedImage
    return blurredImage
}

// *************************** Convert String To Date ****************************

func convertStringintoDate(dateStr:String, dateFormat format:String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
    dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT")
    dateFormatter.dateFormat = format
    if let startDate = dateFormatter.date(from: dateStr){
        return startDate as Date
    }
    return Date() as Date
}

// ******************** convert date time to time **********************
func getTimeFromDate(_ dateString : String) -> (String) {
    let dateFormatter = DateFormatter()
    // dateFormatter.timeZone = TimeZone(abbreviation:"UTC")
    dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from: dateString)!
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    let time = formatter.string(from: date) //"10:22 AM"
    return time
}

// ******************** convert date time to time **********************

func getYearStringFromDate(_ date : Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    dateFormatter.timeZone = TimeZone(abbreviation:"UTC")
    dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
    
    let serverString = dateFormatter.string(from: date)
    return serverString
}

// ********************** get Event Date ***********************

func getEventStringFromDate(_ date : Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(abbreviation:"UTC")
    dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
    
    let serverString = dateFormatter.string(from: date)
    return serverString
}

func getCurrentMonthStringFromDate(_ date : Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM"
    dateFormatter.timeZone = TimeZone(abbreviation:"UTC")
    dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
    
    let serverString = dateFormatter.string(from: date)
    return serverString
}

func getCurrentYearStringFromDate(_ date : Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    dateFormatter.timeZone = TimeZone(abbreviation:"UTC")
    dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
    
    let serverString = dateFormatter.string(from: date)
    return serverString
}

func getDaysInMonth(_ year : Int, Month month : Int) -> (Int){
    let dateComponents = DateComponents(year: year, month: month)
    let calendar = Calendar.current
    let date = calendar.date(from: dateComponents)!
    
    let range = calendar.range(of: .day, in: .month, for: date)!
    let numDays = range.count
    return numDays
}

func getMonthYearFromDate(_ dateString : String) -> (String) {
    let dateFormatter = DateFormatter()
    //  dateFormatter.timeZone = TimeZone(abbreviation:"UTC")
    dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from: dateString)!
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM"
    let time = formatter.string(from: date)
    return time
}

func convertDateStringWithFormat(_ dateString : String, dateFormat format:String) -> (String) {
    let dateFormatter = DateFormatter()
    //  dateFormatter.timeZone = TimeZone(abbreviation:"UTC")
    dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from: dateString)!
    let formatter = DateFormatter()
    formatter.dateFormat = format
    let time = formatter.string(from: date)
    return time
}

func convertDateFormat(date:Date, dateFormat format:String) -> (String) {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
    //dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT")
    dateFormatter.dateFormat = format
    if let convertedDate = dateFormatter.string(from: date) as? String {
        return convertedDate as String
    }
    return "\(Date())" as String
}

func convertDateStringWithOldAndNewFormat(_ dateString : String, oldDateFormat oldformat:String, newDateFormat newformat:String) -> (String) {
    let dateFormatter = DateFormatter()
   // dateFormatter.timeZone = TimeZone(abbreviation:"UTC")
    dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = oldformat//"yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from: dateString)!
    let formatter = DateFormatter()
    formatter.dateFormat = newformat
    let time = formatter.string(from: date)
    return time
}


func convertServerToLocalDate(_ dateString : String) -> (String) {
    let dateFormatter = DateFormatter()
    //    dateFormatter.timeZone = TimeZone(abbreviation:"UTC")
    dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from: dateString)!
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy, hh:mm a"
    let time = formatter.string(from: date)
    return time
}

func formattedDateFromCalDateString(dateString: String, withFormat format: String) -> (String?) {
    
    let inputFormatter = DateFormatter()
    inputFormatter.timeZone = TimeZone(abbreviation:"UTC")
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
    
    if let date = inputFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = TimeZone(abbreviation:"UTC")
        outputFormatter.dateFormat = format
        return (outputFormatter.string(from: date))
    }
    return nil
}

func convertDateToString(date: Date) -> (String?) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dateString = dateFormatter.string(from: date)
    return dateString
}

func convertStringToDate(date: String) -> (Date?) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd" //'T'HH:mm:ss.SSS'Z'
    dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let convertedDate = dateFormatter.date(from: date)
    return convertedDate
}

func addDayInDate(date: Date , numberOfDays days:Int) -> (Date?) {
    let tomorrow = Calendar.current.date(byAdding: .day, value: days, to: date)
    return tomorrow
}

func addMonthInDate(date: Date , numberOfMonth month:Int) -> (Date?) {
    let tomorrow = Calendar.current.date(byAdding: .month, value: month, to: date)
    return tomorrow
}

func differenceBetweenTwoDates(startDate: Date, end endDate: Date, calendarComonent component:Calendar.Component) -> (DateComponents?) {
    let difference = Calendar.current.dateComponents([component], from: endDate, to: startDate)
    return difference
    
}

func getDayOfWeek(_ today:String, dateFormat format:String) -> String? {
    var day : String = "Sunday"
    let formatter  = DateFormatter()
    formatter.dateFormat = format
    guard let todayDate = formatter.date(from: today) else { return nil }
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: todayDate)
    switch (weekDay) {
    case 1:
        day = "Sunday"
        let d = day.prefix(3)
        day = "\(d)"
        break
    case 2:
        day = "Monday"
        let d = day.prefix(3)
        day = "\(d)"
        break
    case 3:
        day = "Tuesday"
        let d = day.prefix(4)
        day = "\(d)"
        break
    case 4:
        day = "Wednesday"
        let d = day.prefix(3)
        day = "\(d)"
        break
    case 5:
        day = "Thursday"
        let d = day.prefix(5)
        day = "\(d)"
        break
    case 6:
        day = "Friday"
        let d = day.prefix(3)
        day = "\(d)"
        break
    default:
        day = "Saturday"
        let d = day.prefix(3)
        day = "\(d)"
        break
    }
    return day
}

func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}

//func getMatchedString(text: String, matchstr: String) -> String? {
//    if var textstr  = text as? String {
//        if textstr.contains(find: matchstr){
//            textstr = textstr.slice(from: matchstr, to: ";")!
//            print(textstr)
//            return textstr
//        }
//    }
//    return ""
//}

func json(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}


//************************* Get UserInfo ********************
//func getUserInfo (_ key: String) -> (String) {
//    let userDetail = fetchObjectDict(key: LoginDetailKey)
//    var userId = ""
//    if let usrId = userDetail[key] as? String {
//        userId = "\(usrId)"
//    }
//    else {
//        userId = ""
//    }
//    return userId
//}
//
//************************* Get UserInfoBool ********************
//func getUserInfoBool (_ key: String) -> (Bool) {
//    let userDetail = fetchObjectDict(key: LoginDetailKey)
//    var userId = false
//    if let usrId = userDetail[key] as? Bool {
//        userId = usrId
//    }
//    else {
//        userId = false
//    }
//    return userId
//}
//
//
//
//
//
//************************* Get HelpForId ********************
//func getValueFromDict (_ key: String, DictKey dict_key:String) -> (String) {
//    let userDetail = fetchObjectDict(key: LoginDetailKey)
//    var userId = ""
//    if let helpForDict = userDetail[dict_key] as? [String : Any] {
//        if let usrId = helpForDict[key] as? String {
//            userId = "\(usrId)"
//        }
//        else {
//            userId = ""
//        }
//    }
//    else {
//        userId = ""
//    }
//    return userId
//}
//
//
//
//func openUrl (_ urlStr:String) {
//    if let url = URL(string: urlStr) {
//        if UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
//}

// ************************ Set Table BackGround for no message view ********************

func emptyMessage(message:String, tableView:UITableView) {
    let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    let messageLabel = UILabel(frame: rect)
    messageLabel.text = message
    messageLabel.textColor = UIColor.white
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    messageLabel.font = UIFont(name: "HelveticaNeue", size: 15)
    messageLabel.sizeToFit()
    tableView.backgroundView = messageLabel;
    tableView.separatorStyle = .none
}

func emptyMessageWithImage(image:UIImage, tableView:UITableView) {
    //create a lable size to fit the Table View
    let noMessageView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    noMessageView.backgroundColor = UIColor.init(patternImage: image)
    //set back to label view
    tableView.backgroundView = noMessageView
    //no separator
    tableView.separatorStyle = .none
}

// ************************ Set Collection BackGround for no message view ********************

func emptyMessageForCollectionView(message:String, collectionView:UICollectionView) {
    let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
    let messageLabel = UILabel(frame: rect)
    messageLabel.text = message
    messageLabel.textColor = #colorLiteral(red: 0.6941176471, green: 0.6901960784, blue: 0.6941176471, alpha: 1)
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    let isIpad = getDeviceType(.pad)
    if (isIpad) {
        messageLabel.font = UIFont(name: "Avenir Next Demi Bold", size: 22)
    }
    else {
        messageLabel.font = UIFont(name: "Avenir Next Demi Bold", size: 17)
    }
    messageLabel.sizeToFit()
    collectionView.backgroundView = messageLabel;
}

/********************* Internet Handling *******/
func isInternetAvailable() -> Bool
{
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}

// **************************** Device Type ************

func getDeviceType(_ deviceType : UIUserInterfaceIdiom) -> Bool {
    let userInterface = UIDevice.current.userInterfaceIdiom
    if(userInterface == deviceType) {
        return true
    }
    else {
        return false
    }
}

// ************************* Device Orientation ****************
func isDeviceLandscape() -> Bool {
    if UIDevice.current.orientation.isLandscape {
        return true
    } else {
        return false
    }
}

// ***********************Toast Message ************************//
func showToast(message : String, vc : UIViewController, normalColor : Bool) {
    
    let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 55))
       if normalColor {
            toastLabel.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
       }
       else {
           toastLabel.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
       }
    
//    let toastLabel = UILabel(frame: CGRect(x: vc.view.frame.size.width/2 - 150, y: vc.view.frame.size.height-100, width: 300, height: 45))
//    if normalColor {
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//    }
//    else {
//        toastLabel.backgroundColor = UIColor(red: 20/255, green: 123/255, blue: 128/255, alpha: 0.6)
//    }
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center;
    toastLabel.numberOfLines = 2
    toastLabel.font = UIFont(name: "Montserrat-Light", size: 8.0)
  
    toastLabel.text = message
    toastLabel.alpha = 1.0
    
    toastLabel.clipsToBounds  =  true
    vc.view.addSubview(toastLabel)
//    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//        toastLabel.alpha = 0.0
//    }, completion: {(isCompleted) in
//        toastLabel.removeFromSuperview()
//    })
    
     let screenWidth = UIScreen.main.bounds.height
    toastLabel.center.y = -50
    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                         animations: {
                         toastLabel.center.y = 80
                         toastLabel.isHidden = false
                         
          }, completion:{ _ in
           UIView.animate(withDuration: 2, delay: 1, options: [.curveEaseOut],
                                   animations: {
                                   toastLabel.center.y = -50
                                  // toastLabel.isHidden = true
                                    
           } )
    })
    
}



//************************ Check Field is empty or not (validation) *******************************//

func checkEmptyField(fieldName : Any,vc: UIViewController,message : String) -> Bool{
    
    guard fieldName != nil && String(describing:fieldName) != "" else{
        showToast(message: message, vc: vc, normalColor: true)
        return false
    }
    return true
    
}


// ************************ Combine Records for Previous To Next View Controller *******************

typealias NameDictRecords = (dict: [String:Any], target: String)

//


func UnwarppingValue(value : Any?)->String{
    
    if let value1 = value{
        let value2 = String(describing: value1)
        if value2 == ""{
            return "N/A"
        }
        else{
            return String(describing: value1)
        }
    }
    else{
        return "N/A"
    }
}
//**************************** table cell registration ************************************

func tableRegistration(tblview : UITableView , identifier : String , nibname : String){
    tblview.register(UINib(nibName: nibname, bundle: nil), forCellReuseIdentifier: identifier)
    tblview.separatorStyle = .none
}
public extension UITableView{
    func addNoRecord(_ msg : String?){
        let label = UILabel(frame: CGRect(x: 0, y: (self.frame.size.height/2)-15, width: self.frame.size.width, height: self.frame.size.height))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: "Helvetica-Bold", size: 14.0)
        label.textAlignment = NSTextAlignment.center
        label.text = (msg == nil) ? ("No_Record_Found") : msg
        self.backgroundView = label
    }
    
    func removeNoRecord(){
        self.backgroundView = nil
    }
    
}


public extension UICollectionView{
    func addNoRecord(_ msg : String?){
        let label = UILabel(frame: CGRect(x: 0, y: (self.frame.size.height/2)-15, width: self.frame.size.width, height: self.frame.size.height))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: "Helvetica-Bold", size: 14.0)
        label.textAlignment = NSTextAlignment.center
        label.text = (msg == nil) ? ("No_Record_Found") : msg
        label.numberOfLines = 0
        self.backgroundView = label
    }
    
    func removeNoRecord(){
        self.backgroundView = nil
    }
    
}

func setGradient1(view : CALayer,color : [CGColor]){
    var gradientLayer: CAGradientLayer!
    gradientLayer = CAGradientLayer()
    gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
    //        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.1)
    gradientLayer.frame = view.bounds
    
    gradientLayer.colors = color
    view.insertSublayer(gradientLayer, at: 0)
}

func setGradientTopBottom(view : CALayer,color : [CGColor]){
     var gradientLayer: CAGradientLayer!
       gradientLayer = CAGradientLayer()
       gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
       //        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.1)
       gradientLayer.frame = view.bounds
       
       gradientLayer.colors = color
       view.insertSublayer(gradientLayer, at: 0)
}
//*********************************************** animation buzz *************************************************************
func buzz(view : AnyObject) {
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.05
    animation.repeatCount = 3
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 5.0, y: view.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 5.0, y: view.center.y))
    if #available(iOS 13.0, *) {
        view.layer.add(animation, forKey: "position")
    } else {
        // Fallback on earlier versions
    }
}
func buzzArray(view : [AnyObject]) {
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.05
    animation.repeatCount = 3
    animation.autoreverses = true
    for i in view{
        animation.fromValue = NSValue(cgPoint: CGPoint(x: i .center.x - 5.0, y: i .center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: i .center.x + 5.0, y: i .center.y))
        if #available(iOS 13.0, *) {
            i .layer.add(animation, forKey: "position")
        } else {
            // Fallback on earlier versions
        }
    }
    
    
  
}
func checkValidationTextField(textField : AnyObject,vc:UIViewController,view:AnyObject,message:String) -> Bool{
    guard textField.text?.isEmpty == false else {
        showToast(message: message, vc: vc, normalColor: false)
        buzz(view: view)
        return false
    }
    return true
}


func checkValidationButtonText(buttonText : UIButton,defaultText : String ,vc : UIViewController,view:AnyObject, message : String) -> Bool {
    
    guard buttonText.title(for: .normal)?.isEmpty == false && buttonText.title(for: .normal) != defaultText else {
        showToast(message: message, vc: vc, normalColor: false)
        buzz(view: view)
        return false
    }
    return true
}

func configButton(sender : UIButton,color : UIColor){
    
    sender.layer.borderColor = (color as! CGColor)
    sender.setTitleColor(color, for: .normal)
    sender.layer.borderWidth = 1

}

func configArrayButton(sender : [UIButton],color : CGColor,singleButton : UIButton,singleButtonColor : CGColor){
    
    for i in sender{
        i.layer.borderColor = color
        i.setTitleColor(UIColor(cgColor: color), for: .normal)
        i.layer.borderWidth = 1
    }
    singleButton.layer.borderColor = singleButtonColor
    singleButton.setTitleColor(UIColor(cgColor: singleButtonColor), for: .normal)
    singleButton.layer.borderWidth = 1
        

}

//func configArrayShadowButton(sender : [UIButton],color : CGColor,singleButton : UIButton,singleButtonColor : CGColor){
//
//    for i in sender{
//        i.layer.shadowColor = color
//        i.layer.opacity =
//    }
//    singleButton.layer.borderColor = singleButtonColor
//    singleButton.setTitleColor(UIColor(cgColor: singleButtonColor), for: .normal)
//    singleButton.layer.borderWidth = 1
//
//
//}

func setBorder(sender: [UIButton], color : CGColor) {
    for i in sender{
        i.layer.borderWidth = 1
        i.layer.borderColor = color
        i.layer.cornerRadius = i.frame.size.width / 2
        i.clipsToBounds = true
    }

}

func setbtnBorder(sender: [UIButton], color : CGColor) {
    for i in sender{
        i.layer.borderWidth = 1
        i.layer.borderColor = color
        i.layer.cornerRadius = 25
        i.clipsToBounds = true
    }

}

func configArrayButtonTitle(sender : [UIButton],color : CGColor,singleButton : UIButton,singleButtonColor : CGColor){
    
    for i in sender{
        i.setTitleColor(UIColor(cgColor: color), for: .normal)
        
    }
    singleButton.setTitleColor(UIColor(cgColor: singleButtonColor), for: .normal)
        
}

//*************************************************SHOW HIDE VIEW***************************************//
func hideShowView(objView : UIView,hidden : Bool){
    if hidden {
        UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            objView.alpha = 0
        }, completion: { finished in
            objView.isHidden = true
        })

    }else{
        UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            objView.alpha = 1
        }, completion: { finished in
            objView.isHidden = false
        })

    }
    
}


   func showToastAlert(message : String, vc : UIViewController, normalColor : Bool) {
        
    let toastLabel = UILabel(frame: CGRect(x: (SCREEN_WIDTH - 200)/2, y: (SCREEN_HEIGHT - 100)/2, width: 200, height: 40))
               if normalColor {
                    toastLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
               }
               else {
                   toastLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
               }
       
            toastLabel.textColor = UIColor.black
            toastLabel.textAlignment = .center;
            toastLabel.numberOfLines = 2
            toastLabel.font = UIFont(name: "Montserrat-Light", size: 8.0)
            toastLabel.layer.cornerRadius = 10
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.opacity = 1.0
            toastLabel.layer.shadowRadius = 2
            toastLabel.layer.shadowOffset = .zero
            toastLabel.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            toastLabel.clipsToBounds  =  true
            vc.view.addSubview(toastLabel)
               toastLabel.center.y = (SCREEN_HEIGHT - 100)/2
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                                 animations: {
                                 toastLabel.center.y = 80
                                 toastLabel.isHidden = false
                                 
                  }, completion:{ _ in
                   UIView.animate(withDuration: 2, delay: 1, options: [.curveEaseOut],
                                           animations: {
                                           toastLabel.center.y = -50
                                          // toastLabel.isHidden = true
                                            
                   } )
            })
    }

extension UIViewController {
    func getController(controllerId: String, storyBoard: String) -> UIViewController {
        let sb = UIStoryboard(name: storyBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: controllerId)
        return vc
    }
    
    func pushController(storyBord: String,viewController: String ) {
        let vc = getController(controllerId: viewController, storyBoard: storyBord)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

//MARK: Gradient function
func setGradientBackground(view1 : UIView, colorTop: UIColor, colorBottom: UIColor) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.4)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.6)
  //  gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
  //  gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.locations = [0, 1]
    gradientLayer.frame = view1.bounds
    view1.layer.addSublayer(gradientLayer)
  //  view1.layer.insertSublayer(gradientLayer, at: 0)

}
