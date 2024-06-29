//
// https://github.com/atacan
// 29.06.24
	

import Foundation
import AsyncHTTPClient
import Hummingbird

struct ToDoController<Context: RequestContext>: Sendable {
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func addRoutes(to group: RouterGroup<Context>) {
            group
                .post(use: handle)
        }
    
    @Sendable
    func handle(_ request: Request, context: Context) async throws -> HTTPClientResponse {
        var httpRequest = HTTPClientRequest(url: "https://jsonplaceholder.typicode.com/todos/1")
        httpRequest.method = .GET
        let response = try await httpClient.execute(httpRequest, timeout: .minutes(10))
        let responseBody = try await response.body.collect(upTo: 1024 * 1024 * 5)
        let todo = try JSONDecoder().decode(ToDo.self, from: responseBody)
        return response
    }
}

extension HTTPClientResponse: ResponseGenerator {
    public func response(from request: HummingbirdCore.Request, context: some Hummingbird.RequestContext) throws -> HummingbirdCore.Response {
        Response(
            status: .init(code: Int(self.status.code), reasonPhrase: self.status.reasonPhrase),
            headers: .init(self.headers, splitCookie: false),
            body: .init(asyncSequence: self.body)
        )
    }
}


struct ToDo: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}
