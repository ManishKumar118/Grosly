import UIKit
import IBAnimatable

class OrderListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblTracking: UILabel!
    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var lblPlaceOn: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTotalQuantity: UILabel!
    @IBOutlet weak var lblOrderAmount: UILabel!
    @IBOutlet weak var lblPaybleAmount: UILabel!
    @IBOutlet weak var lblOrdermode: UILabel!
    @IBOutlet weak var btnComplete: AnimatableButton!
    @IBOutlet weak var btnOrder: AnimatableButton!
    @IBOutlet weak var btnReorder: AnimatableButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
