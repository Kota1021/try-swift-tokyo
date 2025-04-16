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

extension [Components.Schemas.SponsorGroup] {
    func translate() -> SponsorGroups {
        self.map { $0.translate() }
    }
}

extension Components.Schemas.SponsorGroup {
    func translate() -> SponsorGroupByPlan {
        .init(rank: rank.translate(), sponsors: sponsors.map { $0.translate() })
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

extension Components.Schemas.SponsorPlan {
    func translate() -> Plan {
        switch self {
        case .platinum: .platinum
        case .gold: .gold
        case .silver: .silver
        case .bronze: .bronze
        case .diversity: .diversity
        case .student: .student
        case .community: .community
        case .individual: .individual
        }
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
