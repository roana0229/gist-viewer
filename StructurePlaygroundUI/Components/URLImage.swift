//
//  URLImage.swift
//  StructurePlayground
//
//  Created by roana0229 on 2020/04/10.
//

import Combine
import Foundation
import SwiftUI

private class ImageDownloader: ObservableObject {
    private var cancellables: [AnyCancellable] = []
    var url: String?

    @Published
    var downloadData: Data?

    private(set) lazy var onAppear: () -> Void = { [weak self] in
        guard let self = self else { return }
        self.downloadImage()
    }

    private(set) lazy var onDisappear: () -> Void = { [weak self] in
        guard let self = self else { return }
        self.cancellables.forEach { $0.cancel() }
        self.cancellables = []
    }

    func downloadImage() {
        guard let urlString = url, let imageURL = URL(string: urlString) else { return }
        URLSession.shared.dataTaskPublisher(for: URLRequest(url: imageURL))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { responseData in
                self.downloadData = responseData.data
            }).store(in: &cancellables)
    }
}

struct URLImage: View {
    @ObservedObject
    private var imageDownloader = ImageDownloader()

    init(url: String) {
        imageDownloader.url = url
    }

    var body: some View {
        if let imageData = self.imageDownloader.downloadData {
            let img = UIImage(data: imageData)
            return HStack {
                Spacer(minLength: 0)
                Image(uiImage: img!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear(perform: imageDownloader.onAppear)
                    .onDisappear(perform: imageDownloader.onDisappear)
                Spacer(minLength: 0)
            }
        } else {
            return HStack {
                Spacer(minLength: 0)
                Image(uiImage: UIImage(systemName: "icloud.and.arrow.down")!)
                    .aspectRatio(contentMode: .fit)
                    .onAppear(perform: imageDownloader.onAppear)
                    .onDisappear(perform: imageDownloader.onDisappear)
                Spacer(minLength: 0)
            }
        }
    }
}
