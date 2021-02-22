
import UIKit

class CategoryQuantityVC: UIViewController {

    @IBOutlet weak var lblProductNAme: UILabel!
        @IBOutlet weak var tblViewLst: UITableView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tblViewLst.register(UINib(nibName: "QuantityTableViewCell", bundle: nil), forCellReuseIdentifier: "QuantityTableViewCell")
            self.tblViewLst.delegate = self
            self.tblViewLst.dataSource = self
            // Do any additional setup after loading the view.
        }
        

        @IBAction func cancleAction(_ sender: Any) {
             
             self.dismiss(animated: true)
        }
        
    }

extension CategoryQuantityVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tblViewLst.dequeueReusableCell(withIdentifier: "QuantityTableViewCell") as! QuantityTableViewCell
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 85
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
               let obj = storyboard.instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
            self.parent?.navigationController?.pushViewController(obj, animated: true)

        }
            
    }
