//
//  GistListViewModel.swift
//  StructurePlayground
//
//  Created by roana0229 on 2020/04/02.
//

import Combine
import StructurePlaygroundCore
import StructurePlaygroundRepository
import SwiftUI

struct GistListViewModelFactory {
    public static func make(personalAccessToken: String = PlistEnvironment.githubApiToken.value) -> GistListViewModel {
        GistListViewModel(githubRepository: GitHubRepositoryFactory.make(personalAccessToken: personalAccessToken))
    }

    public static func makeForPreview() -> GistListViewModel {
        let preview = make(personalAccessToken: "")
        preview.gists = (0 ..< 30).map { _ in Gist.dummyForPreview() }
        return preview
    }
}

final class GistListViewModel: ObservableObject, Identifiable {
    private let githubRepository: GitHubRepository

    @Published
    var isLoading: Bool = false
    @Published
    var canMoreLoading: Bool = true
    @Published
    var gists: [Gist] = []
    @Published
    var searchText: String = ""
    @Published
    var isSearching: Bool = false

    fileprivate init(githubRepository: GitHubRepository) {
        self.githubRepository = githubRepository
    }

    private var cancellables: [AnyCancellable] = []

    private var searchTextPublisher: AnyPublisher<String?, Never> {
        $searchText
            .flatMap { (searchText) -> AnyPublisher<String?, Never> in
                Future<String?, Never> { promise in
                    promise(.success(searchText))
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    private(set) lazy var onLoadingAppear: () -> Void = { [weak self] in
        guard let self = self else { return }
        self.isLoading = true

        self.githubRepository.getGists(cursor: self.gists.last?.cursor)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case let .failure(error):
                    self.isLoading = false
                    self.canMoreLoading = false
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.gists.append(contentsOf: response.gists)
                self.canMoreLoading = self.gists.count < response.gistCount
            }).store(in: &self.cancellables)
    }

    private(set) lazy var onLoadingDisappear: () -> Void = { [weak self] in
    }

    private(set) lazy var onContentAppear: () -> Void = { [weak self] in
        guard let self = self else { return }
        self.searchTextPublisher
            .map { (searchText) -> Bool in
                !(searchText ?? "").isEmpty
            }
            .sink(receiveValue: { [weak self] value in
                self?.isSearching = value
            })
            .store(in: &self.cancellables)
    }

    private(set) lazy var onContentDisappear: () -> Void = { [weak self] in
        guard let self = self else { return }
        self.cancellables.forEach { $0.cancel() }
        self.cancellables = []
    }
}
