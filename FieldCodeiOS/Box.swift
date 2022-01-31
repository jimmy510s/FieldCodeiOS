import Foundation

final class Box<T> {

    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T{
        didSet{
            listener?(value)
        }
    }
    
    init(aValue: T){
        self.value = aValue
    }
    
    func bind(listener:Listener?){
        self.listener = listener
//        listener?(value)
    }
    
    func trigger(){
        listener?(value)
    }
}
