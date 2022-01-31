import Foundation

class PostService
{
    private static let SERVICE_URL = "posts/"
    
    public static func getPosts(onSuccess:@escaping(Array<Post>) -> Void,onFail:@escaping(ServerError)->Void)
    {
        let url = NetworkManager.BASE_URL + SERVICE_URL


        NetworkManager.shared.makeJsonRequest(url: url, method: .get, body: nil){
            (jsonResult: NSArray) in

            do{
                let decoder = JSONDecoder()
                let data = try JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
                let resultObj = try decoder.decode(Array<Post>.self, from: data)
                
                onSuccess(resultObj)
                
            }catch{
                print(error)
                onFail(ServerError(msg: "An error has occured", code: NetworkManager.ERROR))
            }
        }
        onFail:{
            serverError in
            onFail(serverError)
        }
    }
    
    public static func updatePost(post:Post,onSuccess:@escaping(Post) -> Void,onFail:@escaping(ServerError)->Void)
    {
        let url = NetworkManager.BASE_URL + SERVICE_URL + String(post.id ?? 0)
        
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(post)

        NetworkManager.shared.makeJsonRequest(url: url, method: .put, body: jsonData){
            (jsonResult: NSDictionary) in

            do{
                let decoder = JSONDecoder()
                let data = try JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
                let resultObj = try decoder.decode(Post.self, from: data)
                
                onSuccess(resultObj)
                
            }catch{
                print(error)
                onFail(ServerError(msg: "An error has occured", code: NetworkManager.ERROR))
            }
        }
        onFail:{
            serverError in
            onFail(serverError)
        }
    }
}
