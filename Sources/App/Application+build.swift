import AsyncHTTPClient
import Hummingbird
import Logging
import NIOCore
import NIOPosix
import ServiceLifecycle

func buildApplication(configuration: ApplicationConfiguration) -> some ApplicationProtocol {
    let eventLoopGroup = MultiThreadedEventLoopGroup.singleton
    let httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
    
    let router = Router()
    router.add(middleware: LogRequestsMiddleware(.debug))
    
    ToDoController(httpClient: httpClient)
        .addRoutes(to: router.group())

    var app = Application(
        router: router,
        configuration: configuration
    )
    app.addServices(HTTPClientService(client: httpClient))
    return app
}

struct HTTPClientService: Service {
    let client: HTTPClient

    func run() async throws {
        try? await gracefulShutdown()
        try await self.client.shutdown()
    }
}
