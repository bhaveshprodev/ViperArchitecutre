import UIKit
import Foundation

class LoginRouter {

	weak var viewController : UIViewController?

}

extension LoginRouter: LoginRouterInput {
    
    func openForgotPasswordModule() {
        let vc = ForgotPasswordFactory.shared.createModule()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openCreateProfileModule(user: User?) {
        let controller = CreateAccountFactory.shared.createModule(user: user)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }

}
