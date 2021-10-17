//
//  WelcomeViewController.swift
//  Spotify_Tut
//
//  Created by Aniket Kumar Thakur on 10/07/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let authVC : AuthViewController = {
        let vc = AuthViewController()
        return vc
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("SignIn with spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didSignInTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sangeet"
        navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.systemGreen
        setupButton()
    }
    
    func setupButton() {
        view.addSubview(signInButton)
        signInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        signInButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func didSignInTapped() {
        navigationItem.largeTitleDisplayMode = .never
        authVC.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.signIn(success:success)
            }
            
        }
        navigationController?.pushViewController(authVC, animated: true)
    }
    
    private func signIn(success:Bool) {
        // successfully signed in or yell for error
        guard success else {
            let alert = UIAlertController(title: "OOP", message: "something went wrong while signin", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true, completion: nil)
    }

}
