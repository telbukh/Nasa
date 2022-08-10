//
//  NasaApi.swift
//  Nasa
//
//  Created by Alexandr Telbukh on 04.08.2022.
//

import Foundation

struct NasaApi: Decodable {
    var copyright: String?
    var date: String
    var explanation: String
    var hdurl: String
    var media_type: String
    var service_version: String
    var title: String
    var url: String
}
