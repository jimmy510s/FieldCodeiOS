import UIKit

class PostDetailsScreen: UIViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvBody: UITextView!
    
    var viewModel: PostDetailsVm!
    
    class func instantiateFromStoryboard() -> PostDetailsScreen{
        let storyboard = UIStoryboard(name: "PostDetailsScreen", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PostDetailsScreen") as! PostDetailsScreen
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Post details";
        
        tfTitle.text = viewModel.post.title
        tvBody.text = viewModel.post.body
        
        addBinders()
    }
    
    private func addBinders(){
        
        viewModel.postUpdated.bind(listener: {
            [weak self] value in
            
            if(true && self != nil){
                self!.showOneActionDialog(title: "FieldCode", message: "Post updated", neutralBtnText: "Done", neutralHandler: {
                    self?.navigationController?.popViewController(animated: true)
                }, parentScreen: self!)
            }
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
    
    @IBAction func onUpdateClicked(){
        
        viewModel.postBody = tvBody.text
        viewModel.updatePost()
    }
}
