//
//  SceneDelegate.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // 設定可見視圖大小
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: creatTapBarController())
        // 開啟windowd為可見
        window?.makeKeyAndVisible()
    }

    private func creatTapBarController() -> UITabBarController {
        let nearbyLandmarkVC = UINavigationController(rootViewController: NearbyLandmarkVC())
        nearbyLandmarkVC.tabBarItem = UITabBarItem(title: "附近景點", image: UIImage(systemName: "airplane"), tag: 0)

        let vc2 = UIViewController()
        vc2.view.backgroundColor = .systemRed
        vc2.tabBarItem = UITabBarItem(title: "未知2", image: UIImage(systemName: "car"), tag: 1)

        let vc3 = UIViewController()
        vc3.view.backgroundColor = .green
        vc3.tabBarItem = UITabBarItem(title: "未知3", image: UIImage(systemName: "tram"), tag: 2)

        let vc4 = UIViewController()
        vc4.view.backgroundColor = .yellow
        vc4.tabBarItem = UITabBarItem(title: "未知4", image: UIImage(systemName: "ferry"), tag: 3)

        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.viewControllers = [nearbyLandmarkVC, vc2, vc3, vc4]
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.tabBar.tintColor = .black
        tabBarController.selectedIndex = 0

        return tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

