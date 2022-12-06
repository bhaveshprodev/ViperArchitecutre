import Foundation

protocol LoginRouterInput {
    
    func openForgotPasswordModule()
    func openCreateProfileModule(user: User?)
    func goBack()
}
