//
//  Story.swift
//  HackerNews
//
//  Created by Muhammad Adam on 2/14/19.
//  Copyright © 2019 Muhammad Adam. All rights reserved.
//
import Foundation

struct Story : Codable {

	let by : String?
	let dead : Bool?
	let deleted : Bool?
	let descendants : Int?
	let id : Int?
	let kids : [Int]?
	let parent : Int?
	let parts : [Int]?
	let poll : Int?
	let score : Int?
	let text : String?
	let time : Int?
	let title : String?
	let type : String?
	let url : String?


	enum CodingKeys: String, CodingKey {
		case by = "by"
		case dead = "dead"
		case deleted = "deleted"
		case descendants = "descendants"
		case id = "id"
		case kids = "kids"
		case parent = "parent"
		case parts = "parts"
		case poll = "poll"
		case score = "score"
		case text = "text"
		case time = "time"
		case title = "title"
		case type = "type"
		case url = "url"
	}


    /// Initializes all properties with nil 
    ///
    ///
    init(by: String? = nil, dead: Bool? = nil, deleted: Bool? = nil, descendants: Int? = nil, id: Int? = nil, kids: [Int]? = nil, parent: Int? = nil, parts: [Int]? = nil, poll: Int? = nil, score: Int? = nil, text: String? = nil, time: Int? = nil, title: String? = nil, type: String? = nil, url: String? = nil){
        self.by = by
        self.dead = dead
        self.deleted = deleted
        self.descendants = descendants
        self.id = id
        self.kids = kids
        self.parent = parent
        self.parts = parts
        self.poll = poll
        self.score = score
        self.text = text
        self.time = time
        self.title = title
        self.type = type
        self.url = url
        
    }
    
}
