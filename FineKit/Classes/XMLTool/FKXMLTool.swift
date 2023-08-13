//
//  FKXMLTool.swift
//  XMLTool
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

/*
 XML 解析类
 */

import UIKit

public class FKXMLTool: NSObject {
    public typealias StartHandle = ((_ elementName: String, _ qName: String?, _ attributes: [String : String])->Void)
    public typealias FoundHandle = ((String)->Void)
    public typealias EndHandle = ((_ elementName: String, _ namespaceURI: String?, _ qName: String?) ->Void)
    public typealias XMLDoneBlock = (_ key: String, _ text: String)->Void
    
    public var startHandleBlock: StartHandle?
    public var foundCharactersBlock: FoundHandle?
    public var endHandleBlock: EndHandle?
    
    public func analyse(text: String, startHandle: StartHandle?, foundHandle: @escaping FoundHandle, endHandle: @escaping EndHandle) {
        
        self.startHandleBlock = startHandle
        self.foundCharactersBlock = foundHandle
        self.endHandleBlock = endHandle
        
        if let data = text.data(using: .utf8) {
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
    }
    
    class public func analyse(text: String, done: @escaping XMLDoneBlock) {
        var name_key = ""
        var kText = ""
        let tName = "<xml>" + text + "</xml>"
        FKXMLTool().analyse(text: tName) { elementName, qName, attributes in
            name_key = elementName
            kText = ""
        } foundHandle: { text in
            let new_text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            kText += new_text
        } endHandle: { elementName, namespaceURI, qName in
            if name_key == elementName {
                done(name_key, kText)
            }
        }
    }
}

extension FKXMLTool: XMLParserDelegate {
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.startHandleBlock?(elementName, qName, attributeDict)
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharactersBlock?(string)
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.endHandleBlock?(elementName, namespaceURI, qName)
    }
}
