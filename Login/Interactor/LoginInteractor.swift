import Foundation
import ObjectMapper

class LoginInteractor {
	weak var output: LoginInteractorOutput?
}

/**
 * Presenter -> Interactor
 */
extension LoginInteractor: LoginInteractorInput {
    
    func login(login: String, password: String, success: @escaping (User?) -> Void, failure: @escaping (String?) -> ()) {
        let params = ["login" : login, "password" : password]
        let endpoint = "auth/login"
        AlamofireHelper.alamofireRequestWithoutTokenFromUrl(endpoint, params: params, method: .post, success: { [weak self] (result) in
            guard let json = result as? [String: Any], let userJSON = json["user"] as? [String: Any]  else {return}
            ServicesAssembly.shared.settingsService.clear()
            let map = Map.init(mappingType: .fromJSON, JSON: userJSON)
            let user = User.init(map: map)
            if let authToken = json["access_token"] as? String {
                ServicesAssembly.shared.settingsService.updateAuthToken(authToken)
            }
            if let expires = json["expires_in"] as? String {
                ServicesAssembly.shared.settingsService.updateExpiry(expires)
            }
            ServicesAssembly.shared.settingsService.updateUserId(user?.id ?? 0)
            ServicesAssembly.shared.settingsService.updateUsername(user?.firstName ?? "")
            success(user)
        }) {[weak self] (error) in
            failure(error)
        }
    }
    
    /*func socialLogin(type: SocialProviderType, token: String, secret: String, success: @escaping (User?) -> Void, failure: @escaping (String?) -> ()) {
        var params = ["access_token" : token]
        if type == .twitter {
            params["secret"] = secret
        }
        let endpoint = "auth/login/\(type.rawValue)"
        AlamofireHelper.alamofireRequestWithoutTokenFromUrl(endpoint, params: params, method: .post, success: { (result) in
            guard let json = result as? [String: Any], let userJSON = json["user"] as? [String: Any]  else {return}
            ServicesAssembly.shared.settingsService.clear()
            let map = Map.init(mappingType: .fromJSON, JSON: userJSON)
            let user = User.init(map: map)
            if let authToken = json["access_token"] as? String {
                ServicesAssembly.shared.settingsService.updateAuthToken(authToken)
            }
            if let expires = json["expires_in"] as? String {
                ServicesAssembly.shared.settingsService.updateExpiry(expires)
            }
            ServicesAssembly.shared.settingsService.updateUserId(user?.id ?? 0)
            ServicesAssembly.shared.settingsService.updateUsername(user?.firstName ?? "")
            success(user)
        }) { (error) in
            failure(error)
        }
    }*/
	
}
