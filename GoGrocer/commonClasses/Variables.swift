

import Foundation

class Variables {
    class var sharedVariables : Variables {
        struct Static {
            static let instance : Variables = Variables()
        }
        return Static.instance
    }
    
    var aryCustomProduct : [productVarients_Data] = []
    
    // var arrVarients = [productVarients_Data]()
}
