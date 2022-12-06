/**
 *  Presenter -> View
 */
protocol LoginViewInput: class {

}

/**
 * View -> Presenter
 */
protocol LoginViewOutput {

  	func viewIsReady()
    
    func didTouchLoginButton(_ login: String?, password: String?)
    //func didTouchSocialLogin(with provider: SocialProviderType)
    func didTouchForgotPasswordButton()
    func didTouchBackButton()

}
