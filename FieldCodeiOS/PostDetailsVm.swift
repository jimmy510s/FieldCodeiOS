import Foundation

class PostDetailsVm{
    
    private var postDao = PostDao()
    var post: Post!
    var postBody:String = ""
    var serverError: Box<ServerError>
    var isLoading: Box<Bool> = Box(aValue: false)
    var isPostBodyEmpty: Box<Bool> = Box(aValue: false)
    var postUpdated: Box<Bool> = Box(aValue: false)
    
    init(value:Post){
        self.post = value
        serverError = Box(aValue: ServerError(msg: "", code: NetworkManager.SERVER_OK))
        isPostBodyEmpty = Box(aValue: false)
    }
    
    //here we could use enums if we had more fileds in order to declare different error on each field
    func dataAreValid(body:String)-> Bool{
        return !body.isEmpty
    }
    
    func updatePost(){
        if(dataAreValid(body: postBody)){
            
            guard let detachedPost = DbHelper.detachedCopy(of: post) else{
                print("Could not detach Dog")
                return
             }
            
            detachedPost?.body = postBody
            
            isLoading.value = true
            PostService.updatePost(post: detachedPost!) {
                [weak self] post in
                
                self?.isLoading.value = false
                self?.postUpdated.value = true
                
            } onFail: {
                [weak self] error in
                
                self?.isLoading.value = false
                self?.serverError.value = error
            }

        }else{
            isPostBodyEmpty.value = true
        }
    }
}
