import Foundation

/**
 * Interactor -> Presenter
 */
protocol LoginInteractorOutput: class {

}

/**
 * Presenter -> Interactor
 */
protocol LoginInteractorInput {
    
    func login(login: String, password: String, success: @escaping (User?) -> Void, failure: @escaping (String?) -> ())
    
   // func socialLogin(type: SocialProviderType, token: String, secret: String, success: @escaping (User?) -> Void, failure: @escaping (String?) -> ())

}
