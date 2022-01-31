import Foundation
import RealmSwift

class PostListVm{
    
    private var postDao = PostDao()
    private var notificationToken: NotificationToken?
    var posts: Box<Results<Post>>!
    var serverError: Box<ServerError>
    var isLoading: Box<Bool>
    
    init(){
        
        posts = Box(aValue: postDao.getPosts())
        serverError = Box(aValue: ServerError(msg: "", code: NetworkManager.SERVER_OK))
        isLoading = Box(aValue: false)
    }
    
    func loadPosts(){
        
        posts.trigger()
        
        self.isLoading.value = true
        
        //fetch new data from the api
        PostService.getPosts(onSuccess: {
            [weak self] posts in
        
            self?.isLoading.value = false
            
            self?.postDao.addPosts(array: posts)
            if(!posts.isEmpty){
                self?.posts.value = (self?.postDao.getPosts())!
            }
            
        },onFail: {
            [weak self] error in
            
            self?.isLoading.value = false
            self?.serverError.value = error
            
        })
    }
    
    //we can also add realm listeners (like android does with room) but right now a simpler solution
//    private func addDbListener(){
//
//        notificationToken = posts.value.observe({
//            changes in
//
//            switch changes {
//                case .initial:
//                break;
//
//                case .update(_, let deletions, let insertions, let modifications):
//
//                break
//
//                case .error(let error):
//                break
//            }
//        })
//    }

    func favIsClicked(index:Int){
        
        let pKey = posts.value[index].id!
        let isFav = posts.value[index].isFav
        postDao.updateFav(newValue: !isFav, objId: pKey)
        posts.value = postDao.getPosts()
    }
}
