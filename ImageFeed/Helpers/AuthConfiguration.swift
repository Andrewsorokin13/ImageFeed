import Foundation

let AuthorizURL = "https://unsplash.com/oauth/authorize"
let AccessKey = "wOxFRUzch7zue7IbCjOTpvZUEdrcvxSMGIKChG3bLGc"
let SecretKey = "aVizbi_3xSwj0DB6jK0ntUu7CBpwDTXKN6Whatlzlio"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let Code = "code"
let Scope = "public+read_user+write_likes"
let Authpath = "oauth/authorize/native"

let DefaultBaseURL = URL(string: "https://api.unsplash.com")!

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: Scope,
                                 authURLString: AuthorizURL,
                                 defaultBaseURL: DefaultBaseURL)
    }
}
