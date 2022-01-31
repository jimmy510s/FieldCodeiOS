import Foundation
import RealmSwift

class PostDao{
    
    func getPosts() -> Results<Post> {
        let results: Results<Post> = DbHelper.shared.getDatabase().objects(Post.self)
        return results
     }
    
    func addPosts(array: Array<Post>) {
       try! DbHelper.shared.getDatabase().write {
           for post in array{
               DbHelper.shared.getDatabase().add(post,update: .all)
           }
       }
    }
    
    func updateFav(newValue:Bool,objId:Int){
        
        try! DbHelper.shared.getDatabase().write {
            
            if let tempPost = DbHelper.shared.getDatabase().object(ofType: Post.self, forPrimaryKey: objId){
                tempPost.isFav = newValue
                DbHelper.shared.getDatabase().add(tempPost,update: .all)
            }
        }
    }
}
