//
//  ViewController.swift
//  Weather
//
//  Created by 김원기 on 2022/08/27.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    // IsHidden 속성을 컨트롤 하기 위해
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameTextField.placeholder = "도시를 영어로 입력해주세요."
        
    }

    
    @IBAction func fetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=fb84cedc4a0d7fc406386a4b36ae8168") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url, completionHandler: {
            // 컴플리션 핸들러 선언부에 [weak self] 로 캡쳐리스트 작성
            // 순환 참조 해결
            [weak self] data, response, error in
            guard let data = data, error == nil else {return}
            let decoder = JSONDecoder()
            
            // http status 가 200 번대 이면 응답 받은 json 데이터를 weatherinformation 객체로 디코딩하고
            // 200 번대가 아니라면 error 상태이기 때문에 error 메시지로 디코딩 한다
            let successRange = (200..<300)
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                
                // 네트워크 작업은 별도의 thread 에서 진행 되고 응답이 되어도 자동으로 main thread 로 돌아오지 않는다.
                // completionHandler 에서 UI 작업을 한다면 main thread 에서 작업할 수 있도록 해야한다.
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                    //debugPrint(weatherInformation)
                }
                
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
                //debugPrint(errorMessage)
            }
            
            
        }).resume()
    }
    
    // 입력 받은 값에 대한 정보를 전달하기 위한 메소드
    func configureView(weatherInformation: WeatherInformation) {
        self.cityNameLabel.text = weatherInformation.name
        // weather의 첫번째 요소가 대입되도록
        if let weather = weatherInformation.weather.first {
            self.weatherStatusLabel.text = weather.description
        }
        
        let current = weatherInformation.temp.temp - 273.15
        let max = weatherInformation.temp.maxTemp - 273.15
        let min = weatherInformation.temp.minTemp - 273.15
        
        self.currentTempLabel.text = "\(String(format: "%.1f", current))℃"
        self.maxTempLabel.text = "최고: \(String(format: "%.1f", max)) ℃"
        self.minTempLabel.text = "최저: \(String(format: "%.1f", min)) ℃"
        
        
    }
    
    // error message 를 alert 으로 출력
    func showAlert(message: String) {
        let alert = UIAlertController(title: "잘못된 입력", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

