import Dependencies
import DependenciesMacros
import Foundation
import SharedModels
import OpenAPIRuntime
import OpenAPIURLSession


@DependencyClient
public struct DataClient {
  public var fetchDay1: @Sendable () async throws -> Conference
  public var fetchDay2: @Sendable () async throws -> Conference
  public var fetchDay3: @Sendable () async throws -> Conference
  public var fetchSponsors: @Sendable () async throws -> Sponsors
  public var fetchOrganizers: @Sendable () async throws -> [Organizer]
  public var fetchSpeakers: @Sendable () async throws -> [Speaker]
}

extension DataClient: DependencyKey {
  static private let transport: ClientTransport = URLSessionTransport()
  static private let client = Client(serverURL: try! Servers.Server1.url(), transport: transport) // FIXME: force unwrap

  static public var liveValue: DataClient = .init(
    fetchDay1: {
      let conference = try await client.get_sol_conference(query: .init(title: "2025-day1")).ok.body.json
      return conference.translate()
    },
    fetchDay2: {
      let conference = try await client.get_sol_conference(query: .init(title: "2025-day2")).ok.body.json
      return conference.translate()
    },
    fetchDay3: {
      let conference = try await client.get_sol_conference(query: .init(title: "2025-day3")).ok.body.json
      return conference.translate()
    },
    fetchSponsors: {
      let response = try await client.get_sol_sponsors(headers: .init()).ok.body.json
      return response.translate()
    },
    fetchOrganizers: {
      let response = try await client.get_sol_organizers(headers: .init()).ok.body.json
      return response.map { $0.translate() }
    },
    fetchSpeakers: {
      let response = try await client.get_sol_speakers(headers: .init()).ok.body.json
      return response.map { $0.translate() }
    }
  )
}
