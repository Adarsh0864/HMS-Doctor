//
//  MiddlewareManager.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 19/03/25.
//

import Foundation

private let endpoint = "http://13.233.139.216:8080"

actor MiddlewareManager {

    // MARK: Public

    public static let shared: MiddlewareManager = .init()

    // MARK: Internal

    func get<T: Codable>(url: String, queryParameters: [String: String]? = nil) async -> T? {
        return await request(url: url, method: "GET", queryParameters: queryParameters)
    }

    func post<T: Codable>(url: String, body: Data) async -> T? {
        return await request(url: url, method: "POST", body: body)
    }

    func put<T: Codable>(url: String, body: Data) async -> T? {
        return await request(url: url, method: "PUT", body: body)
    }

    func delete(url: String, body: Data) async -> Bool {
        let result: Bool? = await request(url: url, method: "DELETE", body: body)
        return result != nil
    }

    func patch<T: Codable>(url: String, body: Data) async -> T? {
        return await request(url: url, method: "PATCH", body: body)
    }

    // MARK: Private

    private func request<T: Codable>(url: String = "", method: String, body: Data? = nil, queryParameters: [String: String]? = nil) async -> T? {
        var urlString = "\(endpoint)\(url)"

        if let queryParameters, !queryParameters.isEmpty {
            var urlComponents = URLComponents(string: urlString)
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlString = urlComponents?.url?.absoluteString ?? urlString
        }

        guard let url = URL(string: urlString) else {
            fatalError("Oo haseena zulfon waali jaane jahan")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body { request.httpBody = body }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return nil
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)

        } catch {
            return nil
        }
    }
}
