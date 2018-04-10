//
//  SelectWeatherTable.swift
//  OpenWeatherAPI
//
//  Created by 박수현 on 10/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit

class SelectWeatherTable: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let imaURL: String = "https://openweathermap.org/img/w/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Select location"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension SelectWeatherTable: UITableViewDelegate, UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfrow = WeatherDataManager.shread.choiceWeatherData.count
        return numberOfrow ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cellText = WeatherDataManager.shread.choiceWeatherData[indexPath.row]["name"] as! String
        let cellDetailText = (WeatherDataManager.shread.choiceWeatherData[indexPath.row]["temp"] as! Float).rounded()
        let cellImageData = WeatherDataManager.shread.choiceWeatherData[indexPath.row]["icon"] as! String
        let imageData = try! Data(contentsOf: URL(string: "\(self.imaURL)\(cellImageData).png")!)
        
        cell.textLabel?.text = cellText
        cell.detailTextLabel?.text = String(cellDetailText)
        cell.imageView?.image = UIImage(data: imageData)
        return cell
    }
}
