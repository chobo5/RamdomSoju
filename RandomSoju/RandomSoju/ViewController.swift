//
//  ViewController.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/07/16.
//

import UIKit
import CoreLocation
import NMapsMap
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    
    private var mapView = NMFMapView()
    
    private var kakaoViewModel: KakaoAPIViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        locationManager.delegate = self
    }
    
    private func setupMapView() {
        
        self.mapView = NMFMapView(frame: self.view.frame)
        self.view.addSubview(mapView)
        self.mapView.positionMode = .direction
    }
    
    func findPlaceWithKeyword(x: String, y: String, radius: Int, keyword: String) {
        let headers: HTTPHeaders = ["Authorization": "KakaoAK e09fde1db2267df1c0fe44526622b1b8",
                                    "content-type": "application/json;charset=UTF-8"]
        let parameters: [String: Any] = ["y": y,
                                      "x": x,
                                      "radius": radius,
                                      "query": keyword]
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
        .responseDecodable(of: Keyword.self) {response in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}



extension ViewController: CLLocationManagerDelegate {
    
    // 사용자의 위치를 성공적으로 가져왔을 때 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 위치 정보를 배열로 입력받는데, 마지막 index값이 가장 정확하다고 한다.
        if (locations.last?.coordinate) != nil {
            // ⭐️ 사용자 위치 정보 사용
            
            //현재 위치좌표
            guard let currentLatitude = self.locationManager.location?.coordinate.latitude else { return }
            
            guard let currentLongitude = self.locationManager.location?.coordinate.longitude else { return }
            
            print("location", currentLatitude, currentLongitude)
            
            let camerUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentLatitude, lng: currentLongitude), zoomTo: 17.0)
            
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: currentLatitude, lng: currentLongitude)
            
    
            camerUpdate.animation = .easeIn
            self.mapView.moveCamera(camerUpdate)
            marker.mapView = mapView
            
            findPlaceWithKeyword(x: String(describing: currentLatitude), y: String(describing: currentLongitude), radius: 500, keyword: "술집")
            
            
        
        }
        
        // startUpdatingLocation()(지속적으로 위치요청)을 사용하여 사용자 위치를 가져왔다면
        // 불필요한 업데이트를 방지하기 위해 stopUpdatingLocation을 호출
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        showRequestLocationServiceAlert()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    //MARK: - 앱의 위치서비스 체크 로직: 위치 서비스 활성화 여부 체크 -> 권한 체크
    func checkUserDeviceLocationServiceAuthorization() {
        
        // 3.1 디바이스의 위치 서비스의 활성화 여부 체크
        guard CLLocationManager.locationServicesEnabled() else {
            // 시스템 설정으로 유도하는 커스텀 얼럿
            showRequestLocationServiceAlert()
            return
        }
        
        // 3.2 앱의 위치 서비스 이용 권한 확인
        let authorizationStatus: CLAuthorizationStatus
        
        // 앱의 권한 상태 가져오는 코드
        authorizationStatus = locationManager.authorizationStatus
        
        // 권한 상태값에 따라 분기처리를 수행하는 메서드 실행
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
            
            // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // 권한 요청을 보낸다.
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
            // 시스템 설정에서 설정값을 변경하도록 유도한다.
            // 시스템 설정으로 유도하는 커스텀 얼럿
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
            // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
            locationManager.startUpdatingLocation()
            
        default:
            print("Default")
        }
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
}

