import Foundation
import CoreData
import Alamofire

protocol DetailFetching {
    func deleteAllDetailUserEntities(in context: NSManagedObjectContext)
    func fetchDetailUser(detailURL: String, completion: @escaping ([String: Any]?) -> Void)
    func loadDetailDataFromCoreData(completion: @escaping ([UserEntity]) -> Void)
}

class DetailFetcher: DetailFetching {
    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func deleteAllDetailUserEntities(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Lỗi khi xóa DataUserEntities: \(error)")
        }
    }

    func fetchDetailUser(detailURL: String, completion: @escaping ([String: Any]?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            AF.request(detailURL).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let context = self.persistentContainer.viewContext
                        self.deleteAllDetailUserEntities(in: context)
                        if let name = json["name"] as? String,
                           let email = json["email"] as? String,
                           let avatar_url = json["avatar_url"] as? String,
                           let created_at = json["created_at"] as? String,
                           let followers = json["followers"] as? Int32 {
                            let detailUser = UserEntity(context: context)
                            detailUser.name = name
                            detailUser.email = email
                            detailUser.avatar_url = avatar_url
                            detailUser.created_at = created_at
                            detailUser.followers = followers
                            
                            do {
                                try context.save()
                            } catch {
                                print("Lỗi khi lưu vào Core Data: \(error)")
                            }
                        }
                        
                        DispatchQueue.main.async {
                            completion(json)
                        }
                    }
                case .failure(let error):
                    print("Lỗi khi lấy dữ liệu từ API: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func loadDetailDataFromCoreData(completion: @escaping ([UserEntity]) -> Void) {
        let context = self.persistentContainer.viewContext
        do {
            let dataUsers = try context.fetch(UserEntity.fetchRequest()) as? [UserEntity]
            completion(dataUsers ?? [])
        } catch {
            print("Lỗi khi lấy dữ liệu từ Core Data: \(error)")
            completion([])
        }
    }
}

