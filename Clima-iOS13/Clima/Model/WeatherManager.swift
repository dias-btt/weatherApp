import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithErro(error: Error)
}

struct WeatherManager{
    var weather = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=8696be197905492f1cf9e2b4988d81cf"
    
    var delegate: WeatherManagerDelegate?
    
    func fetch(cityN: String){
        let urlString = "\(weather)&q=\(cityN)"
        performRequest(with: urlString)
    }
    
    func fetch(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weather)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithErro(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temper = decodedData.main.temp
            let cityName = decodedData.name
            let speedW = decodedData.wind.speed
            
            let weatherModel = WeatherModel(conditionId: id, city: cityName, temp: temper, speed: speedW)
            
            return weatherModel
        } catch{
            delegate?.didFailWithErro(error: error)
            return nil
        }
    }
}
