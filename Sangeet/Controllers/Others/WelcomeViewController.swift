//
//  WelcomeViewController.swift
//  Spotify_Tut
//
//  Created by Aniket Kumar Thakur on 10/07/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sangeet"
        navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.systemGreen
    }


}
