//
//  ViewController.swift
//  QMemo
//
//  Created by 박선린 on 5/25/25.
//

import UIKit
import CoreLocation

class CoordinateViewController: UIViewController {
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


//    // 위치 권한 요청
//    func requestLocationPermissionIfNeeded() {
//        let locationManager = CLLocationManager()
//        
//        switch locationManager.authorizationStatus {
//        case .notDetermined:
//            // ✅ 처음 요청
//            locationManager.requestWhenInUseAuthorization()
//            print("📍 위치 권한 요청됨")
//
//        case .restricted:
//            print("⚠️ 위치 사용이 제한됨 (예: 자녀 보호 설정)")
//
//        case .denied:
//            print("❌ 위치 권한 거부됨")
//            DispatchQueue.main.async {
//                // 설정 유도 alert 띄우기 가능
//            }
//
//        case .authorizedWhenInUse, .authorizedAlways:
//            print("✅ 위치 권한 허용됨")
//
//        @unknown default:
//            break
//        }
//    }
    
}
