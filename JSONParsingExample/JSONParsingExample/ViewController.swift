//
//  ViewController.swift
//  JSONParsingExample
//
//  Created by 박수현 on 09/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit

struct WebsiteDescription: Codable {
    let SearchParkInformationByAddressService: SearchParkInfo?
}
struct SearchParkInfo: Codable {
    let listTotalCount: Int?
    let result: Result?
    let row: [Row]?
    private enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case result = "RESULT"
        case row
    }
}
struct Result: Codable {
    let code: String?
    let message: String?
    private enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}
struct Row: Codable {
    let pIdx: String?
    let pPark: String?
    let pListContent: String?
    let pAddress: String?
    let pZone: String?
    let pDivision: String?
    let pImage: String?
    let pAdminTel: String?
    let longitude: Float?
    let latitude: Float?
    let gLongitude: Float?
    let gLatitude: Float?
    
    private enum CodingKeys: String, CodingKey {
        case pIdx = "P_IDX"
        case pPark = "P_PARK"
        case pListContent = "P_LIST_CONTENT"
        case pAddress = "P_ADDR"
        case pZone = "P_ZONE"
        case pDivision = "P_DIVISION"
        case pImage = "P_IMG"
        case pAdminTel = "P_ADMINTEL"
        case longitude = "LONGITUDE"
        case latitude = "LATITUDE"
        case gLongitude = "G_LONGITUDE"
        case gLatitude = "G_LATITUDE"
        
    }
}

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonUrlString = "http://openapi.seoul.go.kr:8088/73646c5059636c61313033614e616c51/json/SearchParkInformationByAddressService/1/5/%EA%B0%95%EB%82%A8"
        guard let url = URL(string: jsonUrlString) else { return }
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: url, completionHandler: {
            (data, response, error) in
            guard let data = data else { return }
            do {
                let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                print(websiteDescription.SearchParkInformationByAddressService?.row![0].pPark)
                
            } catch let jsonErr {
                print("json error:", jsonErr)
            }
            
        })
        task.resume()
        
        
    }
    
    
}
