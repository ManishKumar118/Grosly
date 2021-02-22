import Foundation

// MARK: - Welcome
struct Register: Codable {
    let status, message: String?
    let data: Register_DataClass?
}

struct Register_DataClass: Codable {
    let userID: Int?
    let userName, userPhone, userEmail, deviceID: String?
    let userImage, userPassword: String?
    let otpValue: String?
    let status, wallet, rewards, isVerified: Int?
    let block: Int?
    let regDate: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case userPhone = "user_phone"
        case userEmail = "user_email"
        case deviceID = "device_id"
        case userImage = "user_image"
        case userPassword = "user_password"
        case otpValue = "otp_value"
        case status, wallet, rewards
        case isVerified = "is_verified"
        case block
        case regDate = "reg_date"
    }
    
}

// MARK: - OTP
struct OTP: Codable {
    let status: Int?
    let message: String?
}

// MARK: - Banner
struct Banner: Codable {
    let status, message: String?
    let data: [Banner_Data]?
}

struct Banner_Data: Codable {
    let bannerID: Int?
    let bannerName, bannerImage: String?
    
    enum CodingKeys: String, CodingKey {
        case bannerID = "banner_id"
        case bannerName = "banner_name"
        case bannerImage = "banner_image"
    }
}

// MARK: - footerbanner
struct Footerbanner: Codable {
    let status, message: String?
    let data: [Footerbanner_Data]?
}

struct Footerbanner_Data: Codable {
    let secBannerID: Int?
    let bannerName, bannerImage: String?
    
    enum CodingKeys: String, CodingKey {
        case secBannerID = "sec_banner_id"
        case bannerName = "banner_name"
        case bannerImage = "banner_image"
    }
}


// MARK: - Listing
struct Listing: Codable {
    let status, message: String?
    let data: [Listing_Data]?
}

struct Listing_Data: Codable {
    let storeID, stock, varientID, productID: Int?
    let productName, productImage, datumDescription: String?
    let price, mrp: Int?
    let varientImage: String?
    //let unit: Unit
    let unit: String?
    let quantity, count: Int?

    enum CodingKeys: String, CodingKey {
        case storeID = "store_id"
        case stock
        case varientID = "varient_id"
        case productID = "product_id"
        case productName = "product_name"
        case productImage = "product_image"
        case datumDescription = "description"
        case price, mrp
        case varientImage = "varient_image"
        case unit, quantity, count
    }
}

//MARK:- product Varient
struct ProductVarient: Codable {
    let status, message: String?
    let data: [productVarients_Data]?
}
struct productVarients_Data: Codable {
    let storeID, stock, varientID: Int?
    let datumDescription: String?
    let price, mrp: Int?
    let varientImage, unit: String?
    let quantity: Int
    let dealPrice: Int?
    let validFrom, validTo : String?

    
    enum CodingKeys: String, CodingKey {
        case storeID = "store_id"
        case stock
        case varientID = "varient_id"
        case datumDescription = "description"
        case price, mrp
        case varientImage = "varient_image"
        case unit, quantity
        case dealPrice = "deal_price"
        case validFrom = "valid_from"
        case validTo = "valid_to"
    }
}

// MARK: - TopCategory
struct TopCategory: Codable {
    let status, message: String?
    let data: [TopCategory_Data]?
}

struct TopCategory_Data: Codable {
    let title, image, datumDescription: String?
    let catID, count: Int?
    
    enum CodingKeys: String, CodingKey {
        case title, image
        case datumDescription = "description"
        case catID = "cat_id"
        case count
    }
}

// MARK: - ExpendCategory
class ExpendCategory: Codable {
    let status, message: String?
    let data: [ExpendCategory_Data]?
}

class ExpendCategory_Data: Codable {
    let catID: Int?
    let title, slug, image: String?
    let parent, level: Int?
    let datumDescription: String?
    let status: Int?
    let subcategory: [ExpendCategory_Data]?
   // let subchild: [String]? //by Pooja
    var opened = Bool()
    enum CodingKeys: String, CodingKey {
        case catID = "cat_id"
        case title, slug, image, parent, level
        case datumDescription = "description"
        case status, subcategory //subchild // bypooja
    }
}

// MARK: - AboutUS
struct AboutUS: Codable {
    let status, message: String?
    let data: About_us_Data?
}

struct About_us_Data: Codable {
    let aboutID: Int?
    let title, dataDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case aboutID = "about_id"
        case title
        case dataDescription = "description"
    }
}

// MARK: - WalletAmount
struct WalletAmount: Codable {
    let status, message: String?
    let data: Int?
}

// MARK: - Profile
struct Profile: Codable {
    let status, message: String?
    let data: Profile_Data?
}

struct Profile_Data: Codable {
    let notiID, userID, sms, app: Int?
    let email: Int?
    
    enum CodingKeys: String, CodingKey {
        case notiID = "noti_id"
        case userID = "user_id"
        case sms, app, email
    }
}

// MARK: - UpdateProfile
struct UpdateProfile: Codable {
    let status, message: String?
    let data: Int?
}



// MARK: - CategoryProduct
struct CategoryProduct: Codable {
    let status, message: String?
    let data: [CategoryProduct_data]?
}

struct CategoryProduct_data: Codable {
    let productID, catID: Int?
    let productName, productImage: String?
    let varients: [CategoryProduct_Varient]?
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case catID = "cat_id"
        case productName = "product_name"
        case productImage = "product_image"
        case varients
    }
}

// varients
struct CategoryProduct_Varient: Codable {
    let varientID, productID, quantity: Int?
    //let unit: Unit
    let unit : String?
    let mrp, price: Int?
    let varientDescription, varientImage: String?
    
    enum CodingKeys: String, CodingKey {
        case varientID = "varient_id"
        case productID = "product_id"
        case quantity, unit, mrp, price
        case varientDescription = "description"
        case varientImage = "varient_image"
    }
}

enum Unit: String, Codable {
    case g = "G"
    case kg = "KG"
    case ltr = "Ltr"
}

//MARK: - Notification
struct Notification: Codable {
    let status, message: String?
    let data: [Notification_data]?
}

struct Notification_data: Codable {
    let notiID, userID: Int?
    let notiTitle: String?
    let notiMessage: String?
    let readByUser: Int?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case notiID = "noti_id"
        case userID = "user_id"
        case notiTitle = "noti_title"
        case notiMessage = "noti_message"
        case readByUser = "read_by_user"
        case createdAt = "created_at"
    }
}

enum NotiTitle: String, Codable {
    case hello = "Hello"
    case offer = "Offer"
    case sds = "sds"
    case wooHooYourOrderIsPlaced = "WooHoo! Your Order is Placed"
}


// MARK: - PastOrderDetail
struct PastOrderDetail: Codable {
    let status, message: String?
    let data: [PastOrderDetail_Data]?
}

// MARK: - Datum
struct PastOrderDetail_Data: Codable {
    let orderStatus, deliveryDate, timeSlot, paymentMethod: String?
    let paymentStatus: String?
    let paidByWallet: Int?
    let cartID: String?
    let price, delCharge, remainingAmount, couponDiscount: Int?
    let dboyName, dboyPhone: String?
    let varient: [OrderDetail_Varient]?

    enum CodingKeys: String, CodingKey {
        case orderStatus = "order_status"
        case deliveryDate = "delivery_date"
        case timeSlot = "time_slot"
        case paymentMethod = "payment_method"
        case paymentStatus = "payment_status"
        case paidByWallet = "paid_by_wallet"
        case cartID = "cart_id"
        case price
        case delCharge = "del_charge"
        case remainingAmount = "remaining_amount"
        case couponDiscount = "coupon_discount"
        case dboyName = "dboy_name"
        case dboyPhone = "dboy_phone"
        case varient
    }
}

// Varient
struct OrderDetail_Varient: Codable {
    let storeOrderID: Int?
    let productName, varientImage: String?
    let quantity: Int?
    let unit: String?
    let varientID, qty, price, totalMrp: Int?
    let orderCartID, orderDate: String?
    let storeApproval: Int?
    let varientDescription: String?

    enum CodingKeys: String, CodingKey {
        case storeOrderID = "store_order_id"
        case productName = "product_name"
        case varientImage = "varient_image"
        case quantity, unit
        case varientID = "varient_id"
        case qty, price
        case totalMrp = "total_mrp"
        case orderCartID = "order_cart_id"
        case orderDate = "order_date"
        case storeApproval = "store_approval"
        case varientDescription = "description"
    }
}


// MARK: - Make_On_Order
struct Make_On_Order: Codable {
    let status, message: String?
    let data: Make_On_Order_Detail?
}

// MARK: - DataClass
struct Make_On_Order_Detail: Codable {
    let orderID, userID, storeID, addressID: Int?
    let cartID: String?
    let totalPrice, priceWithoutDelivery, totalProductsMrp: Int?
    let paymentMethod: String?
    let paidByWallet, remPrice: Int?
    let orderDate, deliveryDate: String?
    let deliveryCharge: Int?
    let timeSlot: String?
    let dboyID: Int?
    let orderStatus: String?
    let userSignature, cancellingReason: String?
    let couponID, couponDiscount: Int?
    let paymentStatus: String?
    let cancelByStore: Int?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case userID = "user_id"
        case storeID = "store_id"
        case addressID = "address_id"
        case cartID = "cart_id"
        case totalPrice = "total_price"
        case priceWithoutDelivery = "price_without_delivery"
        case totalProductsMrp = "total_products_mrp"
        case paymentMethod = "payment_method"
        case paidByWallet = "paid_by_wallet"
        case remPrice = "rem_price"
        case orderDate = "order_date"
        case deliveryDate = "delivery_date"
        case deliveryCharge = "delivery_charge"
        case timeSlot = "time_slot"
        case dboyID = "dboy_id"
        case orderStatus = "order_status"
        case userSignature = "user_signature"
        case cancellingReason = "cancelling_reason"
        case couponID = "coupon_id"
        case couponDiscount = "coupon_discount"
        case paymentStatus = "payment_status"
        case cancelByStore = "cancel_by_store"
        case updatedAt = "updated_at"
    }
}

// MARK:- City
struct City: Codable {
    let status, message: String?
    let data: [City_Data]?
}

struct City_Data: Codable {
    let cityID: Int?
    let cityName: String?
    
    enum CodingKeys: String, CodingKey {
        case cityID = "city_id"
        case cityName = "city_name"
    }
}

// MARK:- Society
struct Society: Codable {
    let status, message: String?
    let data: [Society_Data]?
}

struct Society_Data: Codable {
    let societyID: Int?
    let societyName: String?
    let cityID: Int?
    
    enum CodingKeys: String, CodingKey {
        case societyID = "society_id"
        case societyName = "society_name"
        case cityID = "city_id"
    }
}

//MARK:- Address
struct Address: Codable {
    let status, message: String?
    let data: [Address_List]?
}

// Datum
struct Address_List: Codable {
    let addressID, userID: Int?
    let receiverName, receiverPhone, city, society: String?
    let houseNo, landmark, state, pincode: String?
    let lat, lng: String?
    let selectStatus: Int?
    let addedAt, updatedAt: String?
    let distance: Double?

    enum CodingKeys: String, CodingKey {
        case addressID = "address_id"
        case userID = "user_id"
        case receiverName = "receiver_name"
        case receiverPhone = "receiver_phone"
        case city, society
        case houseNo = "house_no"
        case landmark, state, pincode, lat, lng
        case selectStatus = "select_status"
        case addedAt = "added_at"
        case updatedAt = "updated_at"
        case distance
    }
}

//MARK:- Timeslot
struct Timeslot: Codable {
    let status, message: String?
    let data: [String]?
}

// MARK: - Minmax
struct Minmax: Codable {
    let status, message: String?
    let data: Minmax_Data?
}

struct Minmax_Data: Codable {
    let minMaxID: Int?
    let minValue, maxValue: String?

    enum CodingKeys: String, CodingKey {
        case minMaxID = "min_max_id"
        case minValue = "min_value"
        case maxValue = "max_value"
    }
}

// MARK: - Delivery
struct Delivery: Codable {
    let status, message: String?
    let data: Delivery_Data?
}

struct Delivery_Data: Codable {
    let id, minCartValue, delCharge: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case minCartValue = "min_cart_value"
        case delCharge = "del_charge"
    }
}

// MARK: - CancelReson
struct CancelReson: Codable {
    let status, message: String?
    let data: [CancelReson_Data]?
}

struct CancelReson_Data: Codable {
    let resID: Int?
    let reason: String?

    enum CodingKeys: String, CodingKey {
        case resID = "res_id"
        case reason
    }
}


// MARK: - CoupenList
struct CoupenList: Codable {
    let status, message: String?
    let data: [CoupenList_Data]?
}

struct CoupenList_Data: Codable {
    let couponID: Int?
    let couponName, couponCode, couponDescription, startDate: String?
    let endDate: String?
    let cartValue, amount: Int?
    let type: String?
    let usesRestriction: Int?

    enum CodingKeys: String, CodingKey {
        case couponID = "coupon_id"
        case couponName = "coupon_name"
        case couponCode = "coupon_code"
        case couponDescription = "coupon_description"
        case startDate = "start_date"
        case endDate = "end_date"
        case cartValue = "cart_value"
        case amount, type
        case usesRestriction = "uses_restriction"
    }
}

// MARK: - ApplyCoupen
struct ApplyCoupen: Codable {
    let status, message: String?
    let data: ApplyCoupen_Data?
}

// MARK: - DataClass
struct ApplyCoupen_Data: Codable {
    let orderID, userID, storeID, addressID: Int?
    let cartID: String?
    let totalPrice, priceWithoutDelivery, totalProductsMrp: Int?
    let paymentMethod: String?
    let paidByWallet, remPrice: Int?
    let orderDate, deliveryDate: String?
    let deliveryCharge: Int?
    let timeSlot: String?
    let dboyID: Int?
    let orderStatus: String?
    let userSignature, cancellingReason: String?
    let couponID, couponDiscount: Int?
    let paymentStatus: String?
    let cancelByStore: Int?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case userID = "user_id"
        case storeID = "store_id"
        case addressID = "address_id"
        case cartID = "cart_id"
        case totalPrice = "total_price"
        case priceWithoutDelivery = "price_without_delivery"
        case totalProductsMrp = "total_products_mrp"
        case paymentMethod = "payment_method"
        case paidByWallet = "paid_by_wallet"
        case remPrice = "rem_price"
        case orderDate = "order_date"
        case deliveryDate = "delivery_date"
        case deliveryCharge = "delivery_charge"
        case timeSlot = "time_slot"
        case dboyID = "dboy_id"
        case orderStatus = "order_status"
        case userSignature = "user_signature"
        case cancellingReason = "cancelling_reason"
        case couponID = "coupon_id"
        case couponDiscount = "coupon_discount"
        case paymentStatus = "payment_status"
        case cancelByStore = "cancel_by_store"
        case updatedAt = "updated_at"
    }
}

// MARK: - Currency
struct Currency: Codable {
    let status, message: String?
    let data: Currency_data?
}

// MARK: - DataClass
struct Currency_data: Codable {
    let id: Int?
    let currencyName, currencySign: String?

    enum CodingKeys: String, CodingKey {
        case id
        case currencyName = "currency_name"
        case currencySign = "currency_sign"
    }
}

// MARK: - RewardLines
struct RewardLines: Codable {
    let status, message, line1, line2: String?
}


// MARK: - ShowCart
struct ShowCart: Codable {
    let status, message: String?
    let totalPrice: Int?
    let data: [ShowCart_Data]?
    
    enum CodingKeys: String, CodingKey {
        case status, message
        case totalPrice = "total_price"
        case data
    }
}

// MARK: - Datum
struct ShowCart_Data: Codable {
    let storeOrderID: Int?
    let productName, varientImage: String?
    let quantity: Int?
    let unit: String?
    let varientID, qty, price, totalMrp: Int?
    let orderCartID, orderDate: String?
    let storeApproval: Int?

    enum CodingKeys: String, CodingKey {
        case storeOrderID = "store_order_id"
        case productName = "product_name"
        case varientImage = "varient_image"
        case quantity, unit
        case varientID = "varient_id"
        case qty, price
        case totalMrp = "total_mrp"
        case orderCartID = "order_cart_id"
        case orderDate = "order_date"
        case storeApproval = "store_approval"
    }
}

// MARK: - AddCart
struct AddCart: Codable {
    let status, message: String?
    let totalPrice: Int?
    let cartItems: [CartItem]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case totalPrice = "total_price"
        case cartItems = "cart_items"
    }
}

// MARK: - CartItem
struct CartItem: Codable {
    let storeOrderID: Int?
    let productName, varientImage: String?
    let quantity: Int?
    let unit: String?
    let varientID, qty, price, totalMrp: Int?
    let orderCartID, orderDate: String?
    let storeApproval: Int?

    enum CodingKeys: String, CodingKey {
        case storeOrderID = "store_order_id"
        case productName = "product_name"
        case varientImage = "varient_image"
        case quantity, unit
        case varientID = "varient_id"
        case qty, price
        case totalMrp = "total_mrp"
        case orderCartID = "order_cart_id"
        case orderDate = "order_date"
        case storeApproval = "store_approval"
    }
}

// MARK: - cancelOrder
struct CancelOrder: Codable {
    let status, message: String?
    let data: Int?
}




//Product
class addProduct {
        var varientID : Int?
        var value : Int?
        var productName : String?
    
    init(value : Int? , varientID : Int?,productName : String?) {
        self.varientID = varientID
        self.value = value
        self.productName = productName
     }
}

class ProductDetailManager: NSObject {
    static let sharedInstance = ProductDetailManager()
    var arrCartValue : [addProduct]?
    private override init() {
        super.init()
    }
    
    var productDetails :[String:Int] = UserDefaults.standard.value(forKey: "productDetails") as? [String:Int] ?? [:]

    func onIncreaseTapped(productId:String) {
        if let productCount = productDetails[productId] {
            productDetails[productId] = productCount + 1
            print("productinsertDetailInc-----\(productCount)")
    
            // Show (productCount + 1)
        } else {
            productDetails[productId] = 1
            // Show 1
        }
    }
    
    func onDecreaseTapped(productId:String) {
        if let productCount = productDetails[productId] {
            if productCount > 1 {
                 print("productinsertDetailDec-----\(productCount)")
                productDetails[productId] = productCount - 1
                // Show (productCount - 1) and enable
            } else {
                productDetails.removeValue(forKey: productId)
                // Show 0 and disable
            }
        }
    }
    
    func getProductCount(productId:String)->Int {
         print("productIDinitial:---------->\(productId)")
        if let productCount = productDetails[productId] {
            print("getproductcount:---------->\(productCount)")
            return productCount
        } else {
             print("getproductcountfailure:---------->")
            return 0
        }
    }
}

