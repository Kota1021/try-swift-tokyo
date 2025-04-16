//
//  Mock.swift
//  MyLibrary
//
//  Created by 松本 幸太郎 on 2025/04/16.
//

import Dependencies
import DependenciesMacros
import Foundation
import SharedModels
import OpenAPIRuntime
import OpenAPIURLSession

extension DataClient: TestDependencyKey {
  static private let transport: ClientTransport = URLSessionTransport()
  static private let client = MockClient()
  static public let testValue: DataClient = .init(
    fetchDay1: {
        let conference = try await client.get_sol_conference(query: .init(title: "2025-day1"), headers: .init()).ok.body.json
        return conference.translate()
    },
    fetchDay2: {
        let conference = try await client.get_sol_conference(query: .init(title: "2025-day2"), headers: .init()).ok.body.json
        return conference.translate()
    },
    fetchDay3: {
        let conference = try await client.get_sol_conference(query: .init(title: "2025-day3"), headers: .init()).ok.body.json
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

struct MockClient: APIProtocol {
    func get_sol_organizers(_ input: Operations.get_sol_organizers.Input) async throws -> Operations.get_sol_organizers.Output {
        let data = loadDataFromBundle(fileName: "organizers")
        let organizers = try jsonDecoder.decode([Organizer].self, from: data)
        try await Task.sleep(for: .seconds(1))
        return .ok(.init(body: .json(organizers.map { $0.translate() })))    }

    func get_sol_speakers(_ input: Operations.get_sol_speakers.Input) async throws -> Operations.get_sol_speakers.Output {
        let data = loadDataFromBundle(fileName: "speakers")
        let speakers = try jsonDecoder.decode([Speaker].self, from: data)
        try await Task.sleep(for: .seconds(1))
        return .ok(.init(body: .json(speakers.map { $0.translate()})))    }

    func get_sol_sponsors(_ input: Operations.get_sol_sponsors.Input) async throws -> Operations.get_sol_sponsors.Output {
        let data = loadDataFromBundle(fileName: "sponsors")
        let sponsors = try jsonDecoder.decode(Sponsors.self, from: data)
        try await Task.sleep(for: .seconds(1))
        return .ok(.init(body: .json(sponsors.translate())))
    }

    func get_sol_conference(_ input: Operations.get_sol_conference.Input) async throws -> Operations.get_sol_conference.Output {
        let data = loadDataFromBundle(fileName: input.query.title)
        let conference = try jsonDecoder.decode(Conference.self, from: data)
        try await Task.sleep(for: .seconds(1))
        return .ok(.init(body: .json(conference.translate())))
    }
}

extension Conference {
    func translate() -> Components.Schemas.Conference {
        .init(
            id: Int.random(in: 1...1000000),
            title: title,
            date: date,
            schedules: schedules.map { $0.translate() }
        )
    }
}

extension Schedule {
    func translate() -> Components.Schemas.Schedule {
        .init(
            id: Int.random(in: 1...1000000),
            time: time,
            sessions: sessions.map { $0.translate() }
        )
    }
}

extension Session {
    func translate() -> Components.Schemas.Session {
        .init(
            title: title,
            speakers: speakers?.map { $0.translate() },
            place: place,
            description: description,
            requirements: requirements
        )
    }
}

extension Speaker {
    func translate() -> Components.Schemas.Speaker {
        .init(
            name: name,
            image_name: imageName,
            bio: bio,
            links: links?.compactMap { $0.translate() }
        )
    }
}

extension Organizer {
    func translate() -> Components.Schemas.Organizer {
        .init(
            id: id,
            name: name,
            image_name: imageName,
            bio: bio,
            links: links?.compactMap { $0.translate() }
        )
    }
}

extension Sponsor {
    func translate() -> Components.Schemas.Sponsor {
        .init(
            id: id,
            name: name ?? "",
            image_name: imageName,
            link: link?.absoluteString ?? "",
            japanese_link: japaneseLink?.absoluteString
        )
    }
}

extension Sponsors {
    func translate() -> Components.Schemas.Sponsors {
        .init(
            platinum: platinum.map { $0.translate() },
            gold: gold.map { $0.translate() },
            silver: silver.map { $0.translate() },
            bronze: bronze.map { $0.translate() },
            diversity: diversity.map { $0.translate() },
            student: student.map { $0.translate() },
            community: community.map { $0.translate() },
            individual: individual.map { $0.translate() }
        )
    }
}

extension Speaker.Link {
    func translate() -> Components.Schemas.Link? {
         .init(
            name: name,
            url: url.absoluteString
        )
    }
}


extension Organizer.Link {
    func translate() -> Components.Schemas.Link? {
         .init(
            name: name,
            url: url.absoluteString
        )
    }
}

func loadDataFromBundle(fileName: String) -> Data {
  let filePath = Bundle.module.path(forResource: fileName, ofType: "json")!
  let fileURL = URL(fileURLWithPath: filePath)
  let data = try! Data(contentsOf: fileURL)
  return data
}

let jsonDecoder = {
  $0.dateDecodingStrategy = .iso8601
  $0.keyDecodingStrategy = .convertFromSnakeCase
  return $0
}(JSONDecoder())
