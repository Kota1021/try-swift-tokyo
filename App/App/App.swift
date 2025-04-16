import AppFeature
import DataClient
import SwiftUI

@main
struct ConferenceApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(
        store: .init(initialState: .init()) {
          AppReducer()
        } withDependencies: {
            $0.dataClient = .testValue
        })
    }
  }
}
