import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int

}
public enum URL {
    case local
    case remote
}

class WeatherServiceImpl: WeatherService
{
    public var myURL: URL
    init() {
        self.myURL = URL.local
    }
    public func getTemperature() async throws -> Int {
        print("getTemperature start")
        var url = ""
        switch myURL {
            case .local:
            print("getTemperature local")
                url = "http://127.0.0.1:8000/data/2.5/weather"
            case .remote:
            print("getTemperature remote")
                url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=<INSERT YOUR API KEY HERE>"
        }
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
                switch response.result {
                    
                case let .success(weather):
                    print("getTemperature await")
                    var temperature = weather.main.temp
                    var temp_min = weather.main.temp_min
                    var tem_max = weather.main.temp_max
                    temperature = temperature-273.15
                    temp_min = temperature-273.15
                    tem_max = temperature-273.15
                    let temperatureAsInteger = Int(temperature)
                    let tem_min_AsInteger = Int(temp_min)
                    let tem_max_AsInteger = Int(tem_max)
                    if (temperatureAsInteger<tem_max_AsInteger && temperatureAsInteger>tem_min_AsInteger)
                    {
                        //temperature is normal
                        continuation.resume(with: .success(0))
                    }
                    else
                    {
                        //temperature is abnormal
                        continuation.resume(with: .success(1))
                    }

                case let .failure(error):
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
}

private struct Weather: Decodable {
    let main: Main
    struct Main: Decodable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
    }
}
