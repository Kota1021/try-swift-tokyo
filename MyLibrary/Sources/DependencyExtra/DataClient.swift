//
//  DataClient.swift
//  MyLibrary
//
//  Created by 松本 幸太郎 on 2025/04/16.
//

import DataClient
import Dependencies

extension DependencyValues {
    public var dataClient: DataClient {
        get { self[DataClient.self] }
        set { self[DataClient.self] = newValue }
    }
}
