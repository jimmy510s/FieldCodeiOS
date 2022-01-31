import Foundation

class LoginRequest:Codable
{
    var Email: String?
    var GoogleId: String?
    var FacebookID: String?
    var AppleId: String?
    var Password: String?
    
    init(mail:String,googleId:String) {
        Email = mail
        GoogleId = googleId
    }
    
    init(mail:String,fbId:String) {
        Email = mail
        FacebookID = fbId
    }
    
    init(appleId:String) {
        AppleId = appleId
    }
    
    init(mail:String,pass:String) {
        Email = mail
        Password = pass
    }
}
