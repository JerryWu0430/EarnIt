//
//  Question.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import Foundation


struct Question: Codable {
    let question: String
    let options: [String]
    let correct_answer: String
    let subject: String
    let sub_topic: String
    let difficulty: Int
}

