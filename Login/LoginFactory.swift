import UIKit

struct LoginFactory {

    private static let _shared = LoginFactory()

    static var shared: LoginFactory {
        return _shared
    }

    func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardId, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: initialControllerID) as? LoginViewController
        let presenter = LoginPresenter()
        presenter.view = controller
        
        let interactor = LoginInteractor()
        let router     = LoginRouter()
        presenter.router = router
        let presentation = PresentationAssembly.shared
        presenter.whisper = presentation.whisper
        presenter.hud = presentation.hud
        router.viewController = controller
        presenter.interactor = interactor
        interactor.output = presenter
        controller?.output = presenter
        return controller!
    }
    
    // MARK:
    let storyboardId = "Login"
    let initialControllerID = "LoginViewController"
}
