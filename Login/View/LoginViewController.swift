import UIKit
import YYImage
class LoginViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet weak var loginTextField: FloatingTextField!
    @IBOutlet weak var passwordTextField: FloatingTextField!
    @IBOutlet weak var imageViewAnimation: YYAnimatedImageView!
    @IBOutlet weak var flagImageView: UIImageView!
    
    var phoneCode: String = ""
    var isFirstLoad: Bool = true
    
    let countryPicker = CountryPicker()
    
    // MARK: Dependencies
    var output: LoginViewOutput!
    
   	// MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        loginTextField.delegate = self
        loginTextField.keyboardType = .phonePad
        let image = YYImage(imageLiteralResourceName: "dancing.gif")
        imageViewAnimation.image = image
//        #if DEBUG
//        loginTextField.text = "pavel.ostanin9330@gmail.com"
//        passwordTextField.text = "12345678"
//        #endif
        /*if let countryCode = countryPicker.getCurrentPhoneCode() {
            loginTextField.placeholder = "Cell"
        }*/
        loginTextField.placeholder = "Cell"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

    // MARK: Actions
    
    @IBAction func login(_ sender: Any) {
        let loginValid = loginTextField.isValid()
        let passwordValid = passwordTextField.isValid()
        if loginValid && passwordValid {
            output.didTouchLoginButton(loginTextField.text, password: passwordTextField.text)
        }
    }
    
   /* @IBAction func twitterLogin(_ sender: Any) {
        output.didTouchSocialLogin(with: .twitter)
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        output.didTouchSocialLogin(with: .facebook)
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        output.didTouchSocialLogin(with: .google)
    }
    
    @IBAction func snapChatLogin(_ sender: Any) {
        output.didTouchSocialLogin(with: .snapChat)
    }
    
    @IBAction func instagramLogin(_ sender: Any) {
        output.didTouchSocialLogin(with: .instagram)
    }
    */
    @IBAction func forgotPassword(_ sender: Any) {
        output.didTouchForgotPasswordButton()
    }
    
    @IBAction func back(_ sender: Any) {
        output.didTouchBackButton()
    }
    @IBAction func selectCountry(_ sender: Any) {
        isFirstLoad = false
        
        let alert = UIAlertController(style: .actionSheet, title: nil)
        alert.addCountryPicker(locale: Locale.current.regionCode ?? "") {[weak self] (phoneCode, countryCode, flag) in
            guard let self = self else {return}
            self.flagImageView.image = flag
            self.loginTextField.text = phoneCode
            self.phoneCode = phoneCode
        }
        alert.addAction(title: "Done", color: .black, style: .default, handler: { _ in
            self.loginTextField.becomeFirstResponder()
        })
        alert.show()
    }
}

// MARK:
extension LoginViewController: LoginViewInput {

}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            if isFirstLoad {
                view.endEditing(true)
                selectCountry(self)
                return false
            }
            else {
               return true
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == loginTextField && phoneCode.count > 0 {
            let text = textField.text!
            let substring = phoneCode
            let substringRange = text.range(of: substring)!
            let immutableRange = NSRange(substringRange, in: text)
            if range.location < (immutableRange.location + immutableRange.length){
                return false
            }
        }
        if textField == loginTextField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 15
        }
        return true
    }
    
}


