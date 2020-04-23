//
//  GistDetailViewModel.swift
//  StructurePlayground
//
//  Created by roana0229 on 2020/04/08.
//

import Combine
import StructurePlaygroundCore
import StructurePlaygroundRepository
import SwiftUI

struct GistDetailViewModelFactory {
    public static func make(personalAccessToken: String, gist: Gist) -> GistDetailViewModel {
        GistDetailViewModel(githubRepository: GitHubRepositoryFactory.make(personalAccessToken: personalAccessToken),
                            gist: gist)
    }

    public static func makeForPreview() -> GistDetailViewModel {
        make(personalAccessToken: "", gist: Gist.dummyForPreview())
    }
}

final class GistDetailViewModel: ObservableObject, Identifiable {
    private let githubRepository: GitHubRepository

    @Published
    var isLoading: Bool = false

    @Published
    var gist: Gist?

    fileprivate init(githubRepository: GitHubRepository, gist: Gist) {
        self.githubRepository = githubRepository
        self.gist = gist
    }

    private var cancellables: [AnyCancellable] = []

    private(set) lazy var onLoadingAppear: () -> Void = { [weak self] in
        self?.isLoading = true
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
