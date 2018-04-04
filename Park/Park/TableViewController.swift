//
//  TableViewController.swift
//  Park
//
//  Created by 박수현 on 04/04/2018.
//  Copyright © 2018 clapwatermelon. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, XMLParserDelegate {

    
    var xmlParser = XMLParser()
    
    var currentElement = ""                // 현재 Element
    var movieItems = [[String : String]]() // 영화 item Dictional Array
    var movieItem = [String: String]()     // 영화 item Dictionary
    
    var pubTitle = "" // 영화 제목
    var contents = "" // 영화 내용
    
    func requestMovieInfo() {
        // OPEN API 주소
        let url = "http://api.koreafilm.or.kr/openapi-data2/service/api105/getOpenDataList"
        
        guard let xmlParser = XMLParser(contentsOf: URL(string: url)!) else { return }
        
        xmlParser.delegate = self;
        xmlParser.parse()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestMovieInfo()
    }
    
    // XMLParserDelegate 함수
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if (elementName == "item") {
            movieItem = [String : String]()
            pubTitle = ""
            contents = ""
        }
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "item") {
            movieItem["title"] = pubTitle
            movieItem["contents"] = contents
            
            movieItems.append(movieItem)
        }
        print(movieItems)
    }
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if (currentElement == "contents") {
            contents = string
        } else if (currentElement == "pubtitle") {
            pubTitle = string
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.movieItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = movieItems[indexPath.row]["title"]
        return cell
    }
    


}
