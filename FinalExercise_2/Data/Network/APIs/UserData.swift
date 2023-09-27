import Foundation
import CoreData
import Alamofire

protocol DataFetching {
    func deleteAllDataUserEntities(in context: NSManagedObjectContext)
    func fetchDataUser(completion: @escaping () -> Void)
    func loadDataFromCoreData(completion: @escaping ([UserEntity]) -> Void)
}

class DataFetcher: DataFetching {
    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func deleteAllDataUserEntities(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Lỗi khi xóa DataUserEntities: \(error)")
        }
    }

    func fetchDataUser(completion: @escaping () -> Void) {
        let apiURL = "https://api.github.com/users"
        DispatchQueue.global(qos: .background).async {
            AF.request(apiURL).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let jsonArray = value as? [[String: Any]] {
                        let context = self.persistentContainer.viewContext
                        self.deleteAllDataUserEntities(in: context)

                        for json in jsonArray {
                            if let login = json["login"] as? String,
                               let html_url = json["html_url"] as? String,
                               let avatar_url = json["avatar_url"] as? String,
                               let url = json["url"] as? String {
                                let dataUser = UserEntity(context: context)
                                dataUser.login = login
                                dataUser.html_url = html_url
                                dataUser.avatar_url = avatar_url
                                dataUser.url = url

                                do {
                                    try context.save()
                                } catch {
                                    print("Lỗi khi lưu vào Core Data: \(error)")
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                case .failure(let error):
                    print("Lỗi khi lấy dữ liệu từ API: \(error)")
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        }
    }

    func loadDataFromCoreData(completion: @escaping ([UserEntity]) -> Void) {
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

