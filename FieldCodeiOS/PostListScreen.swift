import UIKit
import RealmSwift

class PostListScreen: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: PostListVm!
    
    class func instantiateFromStoryboard() -> PostListScreen{
        let storyboard = UIStoryboard(name: "PostListScreen", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PostListScreen") as! PostListScreen
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Posts";
        
        viewModel = PostListVm()
        addBinders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadPosts()
    }
    
    private func addBinders(){
        
        viewModel.posts.bind(listener: {
            [weak self] value in
            self?.tableView.reloadData()
            
        })
        
        viewModel.serverError.bind(listener: {
            [weak self] value in
            
            if(value.errorCode != NetworkManager.SERVER_OK){
                self?.showNotification(message: value.errorMsg)
            }
        })
        
        viewModel.isLoading.bind(listener: {
            [weak self] value in
            
            if(value){
                self?.showLoadingDialog()
            }else{
                self?.hideLoadingDialog()
            }
        })
    }
}

extension PostListScreen: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.posts.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostListRow",for: indexPath) as! PostListRow
        cell.setUp(post: viewModel.posts.value[indexPath.row])
        
        cell.ivFav.tag = indexPath.row
        
        cell.favClosure = {
            [weak self] index in
            
            self?.viewModel.favIsClicked(index: index)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let nextVc = PostDetailsScreen.instantiateFromStoryboard()
        let nextVm = PostDetailsVm(value: viewModel.posts.value[indexPath.row])
        nextVc.viewModel = nextVm
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
}

class PostListRow: UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    @IBOutlet weak var lblIndex: UILabel!
    @IBOutlet weak var ivFav: UIImageView!
    typealias Closure = (Int) -> Void
    var favClosure:Closure?

    func setUp(post:Post)
    {
        lblIndex.text = String(post.id ?? -1)
        lblTitle.text = post.title
        lblBody.text = post.body
        
        if(post.isFav){
            ivFav.image = UIImage(named: "ic_fav")
        }else{
            ivFav.image = UIImage(named: "ic_not_fav")
        }
        
        ivFav.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFavClick)))
    }
    
    @objc func onFavClick(){
        if(favClosure != nil){
            favClosure!(ivFav.tag as Int)
        }
    }
}
