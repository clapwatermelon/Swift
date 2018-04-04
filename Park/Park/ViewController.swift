//
//  ViewController.swift
//  Park
//
//  Created by 박수현 on 04/04/2018.
//  Copyright © 2018 clapwatermelon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate {

    var strXMLData: String = ""
    var currentElement: String = ""
    var passData: Bool=false
    var passName: Bool=false
    var parser = XMLParser()
    
    @IBOutlet var lblParkName : UILabel! = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url: String = "http://openapi.seoul.go.kr:8088/73646c5059636c61313033614e616c51/xml/SearchParkInformationByAddressService/1/5/%EA%B0%95%EB%82%A8"
        
        let urlToSend: URL = URL(string: url)!
       
        parser = XMLParser(contentsOf: urlToSend)!
   
        parser.delegate = self
        let success: Bool = parser.parse()
        if success {
            print("parse success!")
            print(strXMLData)
            lblParkName.text = strXMLData
            
        } else { print("parse failure!") }
        
   
    
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        if(elementName=="P_PARK" || elementName=="P_LIST_CONTENT")
        {
            if(elementName=="P_PARK"){
                passName = true;
            }
            passData = true;
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        
        if(elementName=="P_PARK" || elementName=="P_LIST_CONTENT")
        {
            if(elementName=="P_PARK"){
                passName = false;
            }
            passData = false;
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(passName){
            strXMLData = strXMLData+"\n\n"+string
        }
        
        if(passData)
        {
            //print(string)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
}

