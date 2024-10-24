//
//  NetworkConstants.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

enum NetworkConstants {
    static let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    static let token = "69a72b9d-5370-4d97-9593-9c27f9eb3d0a"

    static let requestHeader = "X-Practicum-Mobile-Token"

    static let putValue = "application/x-www-form-urlencoded"
    static let putHeader = "Content-Type"
    static let connectionValue = "Keep-alive"
    static let connectionHeader = "Connection"
    static let acceptValue = "application/json"
    static let acceptHeader = "Accept"
    static let acceptEncodingValue = "gzip, deflate, br"
    static let acceptEncodingHeader = "Accept-Encoding"
}
