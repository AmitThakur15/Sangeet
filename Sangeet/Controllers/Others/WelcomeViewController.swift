//
//  WelcomeViewController.swift
//  Spotify_Tut
//
//  Created by Aniket Kumar Thakur on 10/07/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let signInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("SignIn with spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
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


}
