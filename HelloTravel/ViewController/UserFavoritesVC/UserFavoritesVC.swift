//
//  UserFavoritesVC.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/27.
//

import UIKit
import SnapKit

class UserFavoritesVC: UIViewController {

    private lazy var viewModel: UserFavoritesVM = {
        var vm = UserFavoritesVM()
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.referenceData()
    }

}
