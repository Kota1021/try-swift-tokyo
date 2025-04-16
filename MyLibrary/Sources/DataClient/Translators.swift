//
//  Translators.swift
//  MyLibrary
//
//  Created by 松本 幸太郎 on 2025/04/16.
//
import Foundation
import SharedModels

extension Components.Schemas.Conference {
    func translate() -> Conference {
        .init(
            id: id,
            title: title,
            date: date,
            schedules: schedules.map { $0.translate() }
        )
    }
}

extension Components.Schemas.Schedule {
    func translate() -> Schedule {
        .init(
            time: time,
            sessions: sessions.map { $0.translate() }
        )
    }
}

extension Components.Schemas.Session {
    func translate() -> Session {
        .init(
            title: title,
            speakers: speakers?.map { $0.translate() },
            place: place,
            description: description,
            requirements: requirements
        )
    }
}

extension Components.Schemas.Speaker {
    func translate() -> Speaker {
        .init(
            name: name,
            imageName: image_name,
            bio: bio,
            links: links?.compactMap { $0.translate() }
        )
    }
}

extension Components.Schemas.Organizer {
    func translate() -> Organizer {
        .init(
            id: id,
            name: name,
            imageName: image_name,
            bio: bio ?? "",
            links: links?.compactMap { $0.translate() }
        )
    }
}

extension Components.Schemas.Sponsor {
    func translate() -> Sponsor {
        .init(
            id: id,
            name: name,
            imageName: image_name,
            link: URL(string: link)
        )
    }
}

extension Components.Schemas.Sponsors {
    func translate() -> Sponsors {
        .init(
            platinum: platinum?.map { $0.translate() } ?? [],
            gold: gold?.map { $0.translate() } ?? [],
            silver: silver?.map { $0.translate() } ?? [],
            bronze: bronze?.map { $0.translate() } ?? [],
            diversity: diversity?.map { $0.translate() } ?? [],
            student: student?.map { $0.translate() } ?? [],
            community: community?.map { $0.translate() } ?? [],
            individual: individual?.map { $0.translate() } ?? []
        )
    }
}

extension Components.Schemas.Link {
    func translate() -> Speaker.Link? {
        guard let url = URL(string: url) else { return nil }
        return .init(
            name: name,
            url: url
        )
    }

    func translate() -> Organizer.Link? {
        guard let url = URL(string: url) else { return nil }
        return .init(
            name: name,
            url: url
        )
    }
}
