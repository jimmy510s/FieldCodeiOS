import Foundation
import Alamofire

class NetworkManager
{
    private static let DOMAIN_URL = "https://jsonplaceholder.typicode.com/"
    static let BASE_URL = DOMAIN_URL
    
    static let SERVER_OK = 10;
    static let ERROR = -10;

    private var manager: Session
    private var reachability: Reachability
    static let shared = NetworkManager()
    
    private init()
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        manager = Alamofire.Session(configuration: configuration)
        
        reachability = Reachability()!
    }
    
    func makeJsonRequest<T: Any>(url:String, method:HTTPMethod, body:Data?,onSuccess:@escaping(T)->Void,onFail:@escaping(ServerError)->Void)
    {
        if(reachability.connection == .none)
        {
            onFail(ServerError(msg: "Check your internet connection", code: NetworkManager.ERROR))
            return
        }
        
        print("Making json request to " + url)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = getHeaders()
        
        if(body != nil){
            request.httpBody = body!
        }

        manager.request(request).responseJSON
        {
            (response) in
            
            switch response.result
            {
                 case .success(let JSON):
                    print("Json request to " + url + " succeeded")
                    let jsonObj = JSON as! T
                    onSuccess(jsonObj)
                    break
                 case .failure(let error):
                    print("Json request to " + url + " failed")
                    print(error)
                    onFail(ServerError(msg: "An error has occured", code: NetworkManager.ERROR))
                    break
            }
        }
    }
    
    
    private func getHeaders() -> [String:String]
    {
        return ["Content-Type":"application/json; charset=utf-8",
                "Accept":"application/json; charset=utf-8"]
    }
}

