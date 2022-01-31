import Foundation
import UIKit
import UserNotifications
import JGProgressHUD


extension DispatchQueue
{
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil)
    {
        DispatchQueue.global(qos: .background).async
        {
            background?()
            
            if let completion = completion
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute:
                {
                    completion()
                })
            }
        }
    }
}

extension UIViewController
{
    @objc func showLoadingDialog()
    {
        let hud = JGProgressHUD()
        hud.show(in: self.view)
    }
    
    @objc func hideLoadingDialog(delay: TimeInterval = 0)
    {
        for subview in view.subviews {
            
            if(subview .isKind(of: JGProgressHUD.self)){
                (subview as! JGProgressHUD).dismiss(afterDelay: delay, animated: true, completion: nil)
            }
        }
    }
    
    func showNotification (message: String, duration:Int = 2)
    {
        let dispatchAfter = DispatchTimeInterval.seconds(duration)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchAfter) {
            alert.dismiss(animated: true)
        }
    }
    
    func showOneActionDialog(title:String,message:String,neutralBtnText:String,neutralHandler:(() -> ())?,parentScreen:UIViewController){
        
        let dialog = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
        dialog.addAction(UIAlertAction(title: neutralBtnText, style: .default, handler: { (action: UIAlertAction!) in
            if(neutralHandler != nil)
            {
                neutralHandler!()
                dialog.dismiss(animated: true, completion: nil)
            }
        }))
        parentScreen.present(dialog, animated: true, completion: nil)
    }
}

extension UIView
{
   func roundCorners(corners: UIRectCorner, radius: CGFloat)
   {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
