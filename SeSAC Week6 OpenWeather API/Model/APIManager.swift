

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    
    static let shared = APIManager()
    private init() { }
    
    typealias weatherCompletionHandler = (WeatherModel) -> Void
    
    func getWeather(lat: Double, lon: Double, completionHandler: @escaping weatherCompletionHandler) {
        
        let url = EndPoint.baseURL
        let parameter: Parameters = [
            "lat": lat,
            "lon": lon,
            "appid": APIKey.OPENWEATHER
        ]
        
        AF.request(url, method: .get, parameters: parameter).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let weatherData = json["weather"].arrayValue[0]
                
                let id = weatherData["id"].intValue
                let main = weatherData["main"].stringValue
                let description = weatherData["description"].stringValue
                let icon = weatherData["icon"].stringValue
                
                let name = json["name"].stringValue
                
                let temp = json["main"]["temp"].doubleValue - 273
                let feelslike = json["main"]["feels_like"].doubleValue - 273
                let tempmin = json["main"]["temp_min"].doubleValue - 273
                let tempmax = json["main"]["temp_max"].doubleValue - 273
                let pressure = json["main"]["pressure"].doubleValue
                let humidity = json["main"]["humidity"].doubleValue
                
                let data = WeatherModel(id: id, main: main, description: description, icon: icon, name: name, temp: temp, feels_like: feelslike, temp_min: tempmin, temp_max: tempmax, pressure: pressure, humidity: humidity)
                
                completionHandler(data)
                
            case .failure(let error):
                print(error)
                
            }
        }
        
        
    }
    
    
}
