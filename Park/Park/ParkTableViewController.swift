//
//  ParkTableViewController.swift
//  Park
//
//  Created by 박수현 on 04/04/2018.
//  Copyright © 2018 clapwatermelon. All rights reserved.
//

import UIKit

class ParkTableViewController: UITableViewController, XMLParserDelegate {

    var xmlParser = XMLParser()
    var currentElement = ""                 //현재 Element
    var parkItems = [[String: String]]()    //공원 item Dictional Array
    var parkItem = [String: String]()       //공원 item Dictionary
    var parkName = ""                       //공원 이름
    var parkContents = ""                   //공원 설명
    
    func requestParkInfo() {
        //뒤에 주소 한글 부분 처리 아직 안함(일단 강남으로 test)
        let url = "http://openapi.seoul.go.kr:8088/73646c5059636c61313033614e616c51/xml/SearchParkInformationByAddressService/1/5/%EA%B0%95%EB%82%A8"
        
        guard let xmlParser = XMLParser(contentsOf: URL(string: url)!) else { return }
        xmlParser.delegate = self
        xmlParser.parse()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        requestParkInfo()
    }

    // MARK: - XMLParserDelegate 함수
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if (elementName == "P_PARK") {
            parkItem = [String: String]()
            parkName = ""
            parkContents = ""
        }
    }
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "P_PARK" ) {
            parkItem["parkName"] = parkName
            parkItem["parkContent"] = parkContents
            parkItems.append(parkItem)
            print(parkItems)
        }
    }
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (currentElement == "P_PARK"){
            parkName = string
        }
        else if (currentElement == "P_LIST_CONTENT") {
            parkContents = string
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.parkItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parkCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = parkItems[indexPath.row]["parkName"]
        //print(cell.textLabel?.text)
        return cell
    }
    


}
