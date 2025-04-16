import ComposableArchitecture
import DataClient
import SharedModels
import SwiftUI

@Reducer
public struct Organizers {
  @ObservableState
  public struct State: Equatable {
    var organizers = IdentifiedArrayOf<Organizer>()
    @Presents var destination: Destination.State?

    public init(
      organizers: IdentifiedArrayOf<Organizer> = [],
      destination: Destination.State? = nil
    ) {
      self.organizers = organizers
      self.destination = destination
    }
  }

  public enum Action: ViewAction {
    case view(View)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)
    case fetchResponse(Result<IdentifiedArrayOf<Organizer>, Error>)

    public enum View {
      case onAppear
      case _organizerTapped(Organizer)
    }

    @CasePathable
    public enum Delegate {
      case organizerTapped(Organizer)
    }
  }

  @Reducer(state: .equatable)
  public enum Destination {
    case profile(Profile)
  }

  @Dependency(DataClient.self) var dataClient

  public var body: some ReducerOf<Organizers> {
    Reduce { state, action in
      switch action {
      case .view(.onAppear):
        return .run { send in
            let response = try! await dataClient.fetchOrganizers()
            await send(.fetchResponse(.success(.init(uniqueElements: response))))
        }
      case let .view(._organizerTapped(organizer)):
        return .send(.delegate(.organizerTapped(organizer)))
      case .delegate:
        return .none
      case .destination:
        return .none
      case .fetchResponse(.success(let organizers)):
        state.organizers.append(contentsOf: organizers)
        return .none
      case .fetchResponse(.failure):
        // TODO: error handling
        return .none
      }
    }
  }
}

@ViewAction(for: Organizers.self)
public struct OrganizersView: View {

  public var store: StoreOf<Organizers>

  public var body: some View {
    List {
      ForEach(store.organizers) { organizer in
        Button {
          send(._organizerTapped(organizer))
        } label: {
          Label {
            Text(LocalizedStringKey(organizer.name), bundle: .module)
          } icon: {
            Image(organizer.imageName, bundle: .module)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .clipShape(Circle())
              .accessibilityIgnoresInvertColors()
          }
        }
      }
    }
    .onAppear {
      send(.onAppear)
    }
    .navigationTitle(Text("Meet Organizers", bundle: .module))
  }
}

#Preview {
  OrganizersView(
    store: .init(
      initialState: .init(),
      reducer: {
        Organizers()
      }))
}
