//
//  DataStructures.swift
//  HistorIA
//
//  Created by Alumno on 15/03/24.
//
// DataStructures.swift
import Foundation

struct ApiResponse: Decodable {
    var title: String
    var topics: [Topic]
    var questions: [Question]
}

struct Topic: Decodable, Hashable{
    var title: String
    var content: String
    var question: Question
}

struct Question: Decodable, Hashable{
    var question_type: QuestionType?
    var content: String
    var correct_options: [String]?
    var incorrect_options: [String]?
    var clue: String
    
}




enum QuestionType: String, Decodable {
    case winnerSelection = "winner_selection"
    case singleSelection = "single_selection"
    case multipleSelection = "multiple_selection"
}
