//
//  AuthManager.swift
//  Spotify_Tut
//
//  Created by Aniket Kumar Thakur on 10/07/21.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    
    struct Constants {
        static let clientId = "2f30973970ff48109dadfa8066ee2dcf"
        static let clientSecret = "5271b0407edd40a6846b81b3473aa72c"
        static let redirectURI = "https://www.google.co.in"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let scopes = "user-read-private%20playlist-modify-private%20playlist-modify-public%20playlist-read-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    public var signInURL: URL? {
        
        let base = "https://accounts.spotify.com/authorize"
        let urlString = "\(base)?response_type=code&client_id=\(Constants.clientId)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: urlString)
    }
    
    private init() {}
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken:String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken:String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate:Date? {
        return UserDefaults.standard.object(forKey: "expirationdate") as? Date
    }
    
    private var shouldRefreshToken:Bool {
        return false
    }
    
    public func exchangeTheCodeForToken(code: String, completion:@escaping ((Bool) -> Void)) {
    // Get the AccessToken
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientId+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Filure to get base 64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
      let task = URLSession.shared.dataTask(with: request) {[weak self] data, response , error in
            if error != nil {
                completion(false)
                return
            }
            guard let thedata = data else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: thedata)
                self?.cacheToken(result:result)
                completion(true)
            }catch let someEror{
                print(someEror.localizedDescription)
            }
        }
        task.resume()
    
    }
    
    public func refreshIfNeeded(completion: @escaping((Bool) -> Void)) {
//        guard shouldRefreshToken else {
//            return
//        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        // Refresh the Token
        
        // Get the AccessToken
            guard let url = URL(string: Constants.tokenAPIURL) else {
                return
            }
            
            
            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "grant_type", value: "refresh_token"),
                URLQueryItem(name: "refresh_token", value: refreshToken)
            ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = components.query?.data(using: .utf8)
            
            let basicToken = Constants.clientId+":"+Constants.clientSecret
            let data = basicToken.data(using: .utf8)
            guard let base64String = data?.base64EncodedString() else {
                print("Filure to get base 64")
                completion(false)
                return
            }
            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
            
          let task = URLSession.shared.dataTask(with: request) {[weak self] data, response , error in
                if error != nil {
                    completion(false)
                    return
                }
                guard let thedata = data else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: thedata)
                    print("Successfully refreshed token")
                    self?.cacheToken(result:result)
                    completion(true)
                }catch let someEror{
                    print(someEror.localizedDescription)
                }
            }
            task.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.accesstoken, forKey: "access_token")
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expiresin)), forKey: "expirationdate")
        
        if let refreshToken = result.refreshtoken {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        
    }
    
}
