import UIKit
import Alamofire
import SDWebImage
import CoreData



class DataUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var dataUserTableView: UITableView!

    var dataUsers: [UserEntity] = []
    var dataFetcher: DataFetching!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SWIFTERS"

        dataUserTableView.dataSource = self
        dataUserTableView.delegate = self
        
        let persistentContainer = NSPersistentContainer(name: "FinalExercise_2")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Can't load data: \(error)")
            }
        }
        dataFetcher = DataFetcher(persistentContainer: persistentContainer)

        fetchData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func fetchData() {
        dataFetcher.fetchDataUser { [weak self] in
            self?.loadDataFromCoreData()
        }
    }


    func loadDataFromCoreData() {
        dataFetcher.loadDataFromCoreData { [weak self] dataUsers in
            self?.dataUsers = dataUsers
            self?.dataUserTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataUserTableView.dequeueReusableCell(withIdentifier: "DataUserCell", for: indexPath) as! DataUserTableViewCell

        let dataUser = dataUsers[indexPath.row]
        cell.imgAvatar.sd_setImage(with: URL(string: dataUser.avatar_url!))
        cell.lblLogin.text = dataUser.login
        cell.btnHtml.setTitle(dataUser.html_url, for: .normal)
        cell.btnHtml.addTarget(self, action: #selector(openURL(_:)), for: .touchUpInside)

        return cell
    }
    
    @objc func openURL(_ sender: UIButton) {
        if let htmlURL = sender.titleLabel?.text, let url = URL(string: htmlURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailUserVC = storyboard?.instantiateViewController(withIdentifier: "DetailUserViewController") as! DetailUserViewController

        let selectedUserData = dataUsers[indexPath.row]
        detailUserVC.detailURL = selectedUserData.url

        navigationController?.pushViewController(detailUserVC, animated: true)
    }
}
