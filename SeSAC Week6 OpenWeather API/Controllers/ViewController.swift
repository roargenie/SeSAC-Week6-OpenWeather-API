

import UIKit
import CoreLocation
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var currentLocationButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    var weatherData: WeatherModel?
    var weatherMainData: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
        tableView.backgroundColor = .clear
        
        tableView.register(UINib(nibName: ImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ImageTableViewCell.identifier)
        tableView.register(UINib(nibName: TextTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TextTableViewCell.identifier)
        
        currentTime()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showRequestLocationServiceAlert()
    }
    
    func currentTime() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "M월 dd일 HH시 mm분"
        currentTimeLabel.text = dateFormatter.string(from: Date())
    }
    
    func setText() {
        weatherMainData = [
            "현재 온도 \(weatherData!.temp)도, 체감온도 \(weatherData!.feels_like)도",
            "최고 온도 \(weatherData!.temp_max)도, 최저온도 \(weatherData!.temp_min)도",
            "습도 \(weatherData!.humidity)",
            "기압 \(weatherData!.pressure)"
        
        ]
        
        
    }
    
       
}

extension ViewController {
    
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            // 14 미만 버전일 경우
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {

            checkUserCurrentLocationAuthorization(authorizationStatus)
            
        } else {
            print("위치서비스가 꺼져있어서 위치권한 요청을 할 수 없습니다.")
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            print("WHEN IN USE, 사용자가 앱을 사용하는 동안 허용")

            locationManager.startUpdatingLocation()
           
            
        default :
            // authorized, authorizedawlays
            print("DEFAULT")
            
        }
        
        
    }
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          // 애플이 설정창으로 갈 수 있게 제공해줌
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            
            APIManager.shared.getWeather(lat: coordinate.latitude, lon: coordinate.longitude) { data in
                print(data)
                self.weatherData = data
                self.currentLocationButton.setTitle(" \(data.name) ", for: .normal)
                
                self.setText()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherMainData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < weatherMainData.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            
            cell.setUI(text: weatherMainData[indexPath.row])
            return cell
        } else if indexPath.row == weatherMainData.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }
            
            if let image = weatherData?.icon {
                let imageURL = URL(string: "\(EndPoint.imageURL)" + image + "@2x.png")
                cell.weatherImageView.weatherImageView.kf.setImage(with: imageURL)
            }
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < weatherMainData.count {
            return UITableView.automaticDimension
        } else {
            return 200
        }
    }
}



