import Foundation
import RealmSwift

class DbHelper {
    
    private var database:Realm
    static let shared = DbHelper()
    
    private init() {
        
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config

        database = try! Realm()
    }
    
    func getDatabase() -> Realm{
        return database
    }
    
    static func detachedCopy<T:Codable>(of object:T) -> T?{
        
        do{
            let json = try JSONEncoder().encode(object)
            return try JSONDecoder().decode(T.self, from: json)
        }
        catch let error{
            print(error)
            return nil
        }
    }
}
