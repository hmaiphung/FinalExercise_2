//
//  DetailUserViewController.swift
//  FinalExercise_2
//
//  Created by Phung Huy on 20/09/2023.
//

import UIKit
import Alamofire
import SDWebImage
import CoreData


class DetailUserViewController: UIViewController {
    
    
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var lblDetailName: UILabel!
    @IBOutlet weak var imgDetailAvatar: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblFollower: UILabel!
    @IBOutlet weak var lblCreatAt: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    var detailURL: String!
    var detailUsers: [String: Any] = [:]
    var detailFetcher: DetailFetching!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let persistentContainer = NSPersistentContainer(name: "FinalExercise_2")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Không thể tải cơ sở dữ liệu: \(error)")
            }
        }
        detailFetcher = DetailFetcher(persistentContainer: persistentContainer)
        
        fetchDetail()
        
    }
    
    func fetchDetail() {
        detailFetcher.fetchDetailUser(detailURL: detailURL) { [weak self] detailData in
            if let detailData = detailData {
                self?.detailUsers = detailData
                self?.updateUIWithData()
            } else {
               
            }
        }
    }

    func updateUIWithData() {
        imgLogo.image = UIImage(named: "logo")
        lblDetailName.text = detailUsers["name"] as? String ?? "N/A"
        lblFollower.text = "\(detailUsers["followers"] as? Int ?? 0) Followers"
        lblEmail.text = "Email: \(detailUsers["email"] as? String ?? "Email Not Available")"
        
        if let createdAtString = detailUsers["created_at"] as? String {
            let formattedCreatedAt = formatDateString(createdAtString)
            lblCreatAt.text = "Since: \(formattedCreatedAt)"
        } else {
            lblCreatAt.text = "Since: N/A"
        }
        
        if let avatarURLString = detailUsers["avatar_url"] as? String, let avatarURL = URL(string: avatarURLString) {
            imgDetailAvatar.sd_setImage(with: avatarURL)
        }
    }
}
