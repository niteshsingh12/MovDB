//
//  FakeStub.swift
//  MoviDBTests
//
//  Created by Nitesh Singh on 01/07/22.
//

import Foundation

class FakeStub {

    // MARK: - Data

    static func generateFakeDataFromJSONWith(fileName: String) -> Data? {
        let bundle = Bundle(for: FakeStub.self)
        let url = bundle.url(forResource: fileName, withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    // MARK: - Response

    static let responsePass = HTTPURLResponse(
        url: URL(string: "https://api.themoviedb.org//3/movie/now_playing")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])

    static let responseFail = HTTPURLResponse(
        url: URL(string: "https://api.themoviedb.org//3/movie/now_playing")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])
}
