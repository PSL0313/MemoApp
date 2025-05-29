//
//  SceneDelegate.swift
//  QMemo
//
//  Created by 박선린 on 5/21/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var alreadyHandledMemoNotification = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)

        // 탭바컨트롤러의 생성
        let tabBarVC = UITabBarController()
        
        // 탭바 속성
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.91, alpha: 1.0)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        
        // 첫번째 화면은 네비게이션컨트롤러로 만들기 (기본루트뷰 설정)
        let vc1 = UINavigationController(rootViewController: MainViewController())
        let vc2 = UINavigationController(rootViewController: MemoListViewController())
//        let vc3 = UINavigationController(rootViewController: UsersViewController())

        
        // 탭바 이름들 설정 안함
//        vc1.title = "Memo"
//        vc2.title = "목록"
//        vc3.title = "Info"

        
        // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
        tabBarVC.setViewControllers([vc1, vc2], animated: false)
//        tabBarVC.setViewControllers([vc1, vc2, vc3], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white
        tabBarVC.tabBar.tintColor = .brown
        
        // 탭바 이미지 설정 (이미지는 애플이 제공하는 것으로 사용)
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "square.and.pencil")
        items[1].image = UIImage(systemName: "folder")
//        items[2].image = UIImage(systemName: "person.circle")
        
            
        // 기본루트뷰를 탭바컨트롤러로 설정⭐️⭐️⭐️
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        
        if let notificationResponse = connectionOptions.notificationResponse {
            let userInfo = notificationResponse.notification.request.content.userInfo
            if let memoID = userInfo["memoID"] as? String {
                tabBarVC.selectedIndex = 1
                NotificationCenter.default.post(
                    name: .didReceiveMemoNotification,
                    object: nil,
                    userInfo: ["memoID": memoID]
                )
                alreadyHandledMemoNotification = true
                
                // ✅ AppDelegate에 있는 것도 초기화
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.launchedMemoID = nil
                }
            }
        }

        // ✅ AppDelegate에 임시 저장된 ID가 있고 아직 처리 안 했다면
        if !alreadyHandledMemoNotification,
           let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let memoID = appDelegate.launchedMemoID {

            tabBarVC.selectedIndex = 1
            NotificationCenter.default.post(
                name: .didReceiveMemoNotification,
                object: nil,
                userInfo: ["memoID": memoID]
            )
            appDelegate.launchedMemoID = nil
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    var didHandleMemoNotification = false

    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let memoID = appDelegate.launchedMemoID else {
            return
        }

        appDelegate.launchedMemoID = nil

        if let tabBarController = window?.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 1
        }

        NotificationCenter.default.post(
            name: .didReceiveMemoNotification,
            object: nil,
            userInfo: ["memoID": memoID]
        )
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        didHandleMemoNotification = false
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

            // 알림 권한 요청
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print("알림 권한 granted: \(granted)")
            }

            // 알림 델리게이트 설정
            UNUserNotificationCenter.current().delegate = self

            return true
        }

        // ✅ 포그라운드에서 알림을 강제로 보여주기 위한 메서드
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .sound]) // 🔔 이걸로 포그라운드에서도 알림 띄움
        }
}

