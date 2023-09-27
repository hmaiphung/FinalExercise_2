//
//  Model.swift
//  FinalExercise_2
//
//  Created by Phung Huy on 20/09/2023.
//

import Foundation

struct DataUser: Codable {
    let login: String
    let html_url: String
    let avatar_url: String
    let url: String
}

struct DetailUser: Codable {
    let name: String
    let avatar_url: String
    let followers: Int32
    let created_at: String
    let email: String
}
