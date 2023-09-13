//
//  ViewController.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/07/16.
//

import UIKit
import CoreLocation
import Alamofire
import NMapsMap
import SnapKit


class ViewController: UIViewController {
   
    private let locationManager = CLLocationManager()
    
    private var mapView = NMFMapView()
    
    private var placeListViewModel = PlaceListViewModel()
    
    private var collectionView: UICollectionView!
    
    private var soolButton: UIButton!
    
    private var refreshButton: UIButton!
    
    var rouletteViewModel = PlaceRouletteViewModel()
    
    private let pathOverlay = NMFPath()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupButton()
        setupCollectionView()
        
        locationManager.delegate = self
        
        
        
        self.placeListViewModel.resultList.bind { [weak self] _ in
            guard let self = self else { return }
            collectionView.reloadData()
//            collectionView.reloadItems(at: [IndexPath(item: <#T##Int#>, section: 0)])
            print("placeListViewModel changed")
        }
        
        self.placeListViewModel.path?.bind({ [weak self] path in
            guard let self = self else { return }
            
            if let path = path?.route?.trafast?[0].path {
                print("path is updated", path)
                var NMGLatLngArray: [NMGLatLng] = []
                
                NMGLatLngArray = path.compactMap { point in
                    return NMGLatLng(lat: point[1], lng: point[0])
                }
                pathOverlay.path = NMGLineString(points: NMGLatLngArray)
                
                pathOverlay.mapView = mapView
            }
        })
        
    }
    
    private func setupMapView() {
        
        self.mapView = NMFMapView(frame: self.view.frame)
        self.view.addSubview(mapView)
        self.mapView.positionMode = .direction
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewPlaceInfoCell.self, forCellWithReuseIdentifier: "placeInfoCell")
        collectionView.backgroundColor = .clear
        
        self.view.addSubview(self.collectionView)
        
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.soolButton.snp.top).offset(-30)
            make.height.equalToSuperview().multipliedBy(0.15)
        }

        layout.itemSize = CGSize(width: self.view.frame.width * 0.35, height: self.view.frame.height * 0.15)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
    }
    
    private func setupButton() {
        self.soolButton = UIButton()
        self.refreshButton = UIButton()
        
        self.view.addSubview(soolButton)
        self.view.addSubview(refreshButton)
        
        self.soolButton.translatesAutoresizingMaskIntoConstraints = false
        self.refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        soolButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(self.soolButton.snp.top)
            make.width.height.equalTo(self.view.snp.height).multipliedBy(0.04)
        }
        
        self.soolButton.layer.cornerRadius = self.view.frame.width * 0.3 * 0.15
        self.soolButton.layer.borderWidth = 1.0
        self.soolButton.layer.borderColor = UIColor.gray.cgColor
        
        self.soolButton.setTitle("수우울", for: .normal)
        self.soolButton.setTitleColor(.black, for: .normal)
        self.soolButton.backgroundColor = .white
        self.soolButton.addTarget(self, action: #selector(soolButtonTapped(sender:)), for: .touchUpInside)
        
        self.refreshButton.layer.borderWidth = 0.5
        self.refreshButton.layer.borderColor = UIColor.gray.cgColor
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let buttonImage = UIImage(systemName: "arrow.clockwise", withConfiguration: imageConfig)
        self.refreshButton.setImage(buttonImage, for: .normal)
        self.refreshButton.tintColor = .gray
        self.refreshButton.backgroundColor = .white
        self.refreshButton.addTarget(self, action: #selector(refreshButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func soolButtonTapped(sender: UIButton) {
        let rouletteVC = RouletteViewController()
        rouletteVC.rouletteViewModel = self.rouletteViewModel
        rouletteVC.dismissDelegate = self
        
        self.present(rouletteVC, animated: true)
        
    }
    
    @objc func refreshButtonTapped(sender: UIButton) {
        print("refreshButtonTapped")
        self.locationManager.startUpdatingLocation()
        self.locationManager.stopUpdatingLocation()
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
            
            self.placeListViewModel.updateCurrentLocation(lon: String(describing: currentLongitude), lat: String(describing: currentLatitude))
            
            let camerUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentLatitude, lng: currentLongitude), zoomTo: 15.5)
            
            

            camerUpdate.animation = .easeIn
            self.mapView.moveCamera(camerUpdate)
            
            
            self.placeListViewModel.getPlaceWithKeyword(x: String(describing: currentLongitude),
                                                    y: String(describing: currentLatitude),
                                                    radius: 500,
                                                    page: 3,
                                                    keyword: "술집") { [weak self] place in
                guard let self = self else { return }
                let marker = NMFMarker()
                guard let placeLat = place.y else { return }
                guard let placeLng = place.x else { return }
                
                guard let DoubleLat = Double(placeLat) else { return }
                guard let DoubleLng = Double(placeLng) else { return }
                marker.position = NMGLatLng(lat: DoubleLat, lng: DoubleLng )
                marker.mapView = self.mapView
            }
            
            
            //마커 달아주기
        
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
//        guard CLLocationManager.locationServicesEnabled() else {
//            // 시스템 설정으로 유도하는 커스텀 얼럿
//            showRequestLocationServiceAlert()
//            return
//        }
        
        // 3.2 앱의 위치 서비스 이용 권한 확인
        let authorizationStatus = locationManager.authorizationStatus
        
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

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = self.placeListViewModel.resultList.value?.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeInfoCell", for: indexPath) as! UICollectionViewPlaceInfoCell
        if let cellViewModel = self.placeListViewModel.cellViewModelForPlace(index: indexPath.row) {
            cell.cellViewModel = cellViewModel
            cell.configure(with: cellViewModel)
            
        }
        cell.cellViewModel?.delegate = self.rouletteViewModel
        
        return cell
        
    }
    
}

extension ViewController: UICollectionViewDelegate, DismissDelegate {
    func dismissAllViewControllers() {
        self.dismiss(animated: true)
    }
    
    
}



