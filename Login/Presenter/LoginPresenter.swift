import Foundation
import UIKit

class LoginPresenter {

    weak var view: LoginViewInput!
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
    
    var whisper: InAppNotificationsProvider!
    var hud: HUD!
    
    //var socialProvider: SocialProvider!
    
}

// MARK: ViewOutput
extension LoginPresenter: LoginViewOutput {

    func viewIsReady() {
        //socialProvider = SocialProvider.init(vc: self.view as! UIViewController, hud: self.hud)
    }
    
    func didTouchLoginButton(_ login: String?, password: String?) {
        hud.show()
        guard let login = login, let password = password else { return }
        interactor.login(login: login, password: password, success: {[weak self] user in
            guard let self = self else {return}
            self.hud.hide()
            self.proccess(user: user)
        }) {[weak self] (error) in
            guard let self = self else {return}
            self.hud.hide()
            if let str = error {
                self.whisper.showErrorString(str, controller: self.view as! UIViewController)
            }
        }
    }
    
   /* func didTouchSocialLogin(with provider: SocialProviderType) {
        hud.show()
        self.socialProvider.provider(for: provider).login(with: { [weak self] (socialUser, token, secret) in
            guard let `self` = self else { return }
            self.interactor.socialLogin(type: provider, token: token, secret: secret, success: { user in
                self.hud.hide()
                self.proccess(user: user)
            }, failure: { (error) in
                self.hud.hide()
                if let str = error {
                    self.whisper.showErrorString(str, controller: self.view as! UIViewController)
                }
            })
        })
    }*/
    
    func didTouchForgotPasswordButton() {
        router.openForgotPasswordModule()
    }
    
    func didTouchBackButton() {
        router.goBack()
    }

}

// MARK: InteractorOutput
extension LoginPresenter: LoginInteractorOutput {

}

// MARK: private methods
extension LoginPresenter {
    
    private func proccess(user: User?) {
        if let user = user {
            if let _ = user.firstName, let _ = user.email, let _ = user.phone {
                (UIApplication.shared.delegate as! AppDelegate).setupRootViewController(isLoginOrSignup: true)
            }
            else {
                router.openCreateProfileModule(user: user)
            }
        } else {
            whisper.showGlobalMessage("These credentials do not match our records.", controller: view as! UIViewController)
        }
    }
    
}


