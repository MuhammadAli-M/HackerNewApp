//
//  API.swift
//  HackerNews
//
//  Created by Muhammad Adam on 2/14/19.
//  Copyright © 2019 Muhammad Adam. All rights reserved.
//

import Foundation
import UIKit

class API {
    enum EndPoint{
        case topStories
        case newStories
        case item(Int)
        
        var url:URL{
            return URL(string: self.stringvalue)!
        }
        private var baseUrlString: String { return "https://hacker-news.firebaseio.com/v0/"}
        
        var stringvalue: String{
            switch self {
            case .topStories: return baseUrlString + "topstories.json"
            case .newStories: return baseUrlString + "newstories.json"
            case .item(let id): return baseUrlString + "item/\(id).json"
            }
        }
    }
    class func requestList(url: URL,completionHandler: @escaping ([Int], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else{
                print("Error while requsting \(url.absoluteString) , error : \(error?.localizedDescription ?? " ")")
                completionHandler([],error)
                return
            }
            let decoder = JSONDecoder()
            do{
                let List = try decoder.decode([Int].self, from: data)
                completionHandler(List,nil)
                print("List is recieved")
            }catch{
                completionHandler([],error)
                print("Error while json parsing, error : \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func requestStory(storyUrl: URL, completionHandler: @escaping (Story?, Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: storyUrl) { (data, response, error) in
            guard let data = data else{
                print("Error while requsting Story with \(storyUrl.absoluteString), error : \(error?.localizedDescription ?? " ")")
                completionHandler(nil,error)
                return
            }
            let decoder = JSONDecoder()
            do{
                let story = try decoder.decode(Story.self, from: data)
                completionHandler(story,nil)
                print("Story with \(storyUrl.absoluteString) are recieved")
            }catch{
                completionHandler(nil,error)
                print("Error while json parsing for Story with \(storyUrl.absoluteString), error : \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else{
                print("Error while requsting imageFile, error : \(error?.localizedDescription ?? " ")")
                completionHandler(nil,error)
                return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage,nil)
            print("ImageFile are recieved")
        }
        task.resume()
    }
    
    
}
