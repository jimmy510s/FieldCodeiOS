import Foundation
import Realm
import RealmSwift

class Post: Object, Codable
{
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var title: String?
    @Persisted var body: String?
    @Persisted var isFav = false
    
    enum CodingKeys: String, CodingKey
    {
        case body = "body"
        case title = "title"
        case id = "id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
        try container.encode(id, forKey: .id)
    }
}

class ServerError
{
    var errorMsg:String
    var errorCode:Int
    
    init(msg:String,code:Int){
        errorMsg = msg
        errorCode = code
    }

}
