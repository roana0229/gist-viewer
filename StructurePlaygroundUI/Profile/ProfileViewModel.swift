//
//  ProfileViewModel.swift
//  StructurePlayground
//
//  Created by roana0229 on 2020/04/14.
//

import Combine
import StructurePlaygroundCore
import StructurePlaygroundRepository
import SwiftUI

struct ProfileViewModelFactory {
    public static func make(personalAccessToken: String = PlistEnvironment.githubApiToken.value) -> ProfileViewModel {
        ProfileViewModel(githubRepository: GitHubRepositoryFactory.make(personalAccessToken: personalAccessToken))
    }

    public static func makeForPreview() -> ProfileViewModel {
        let preview = make(personalAccessToken: "")
        preview.profile = Profile.dummyForPreview()
        return preview
    }
}

final class ProfileViewModel: ObservableObject, Identifiable {
    private let githubRepository: GitHubRepository

    @Published
    var isLoading: Bool = false

    @Published
    var profile: Profile?

    fileprivate init(githubRepository: GitHubRepository) {
        self.githubRepository = githubRepository
    }

    private var cancellables: [AnyCancellable] = []

    private(set) lazy var onLoadingAppear: () -> Void = { [weak self] in
        guard let self = self else { return }
        self.isLoading = true
        self.githubRepository.getProfile()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.profile = response.profile
        }).store(in: &self.cancellables)
    }

    private(set) lazy var onLoadingDisappear: () -> Void = { [weak self] in
        self?.isLoading = false
    }

    private(set) lazy var onContentAppear: () -> Void = { [weak self] in
    }

    private(set) lazy var onContentDisappear: () -> Void = { [weak self] in
        guard let self = self else { return }
        self.cancellables.forEach { $0.cancel() }
        self.cancellables = []
    }
}
