//
//  GistDetailView.swift
//  StructurePlayground
//
//  Created by roana0229 on 2020/04/02.
//

import StructurePlaygroundCore
import SwiftUI

struct GistDetailViewFactory {
    public static func make(gist: Gist,
                            personalAccessToken: String = PlistEnvironment.githubApiToken.value) -> GistDetailView {
        GistDetailView(viewModel:
            GistDetailViewModelFactory.make(personalAccessToken: personalAccessToken,
                                            gist: gist)
        )
    }
}

struct GistDetailView: View {
    @ObservedObject var viewModel: GistDetailViewModel

    var body: some View {
        guard let gist = $viewModel.gist.wrappedValue else {
            return AnyView(
                ZStack {
                    Color.black.opacity(0.6)
                    ActivityIndicator(isAnimating: $viewModel.isLoading, style: .large, color: .white)
                }
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: viewModel.onLoadingAppear)
                .onDisappear(perform: viewModel.onLoadingDisappear)
            )
        }

        return AnyView(
            ContentView(gist: gist)
                .onAppear(perform: viewModel.onContentAppear)
                .onDisappear(perform: viewModel.onContentDisappear)
        )
    }

    private struct ContentView: View {
        let gist: Gist

        var body: some View {
            ScrollView(.vertical, showsIndicators: true) {
                HStack {
                    VStack(alignment: .leading) {
                        Button(gist.url) {
                            if let url = URL(string: self.gist.url) {
                                UIApplication.shared.open(url, options: [:])
                            }
                        }
                        .lineLimit(1)
                        .font(Font.caption)
                        .padding(.bottom, 8)
                        if gist.isPublic {
                            Text("[public]").padding(.trailing, 8)
                                .font(.caption)
                                .foregroundColor(ThemeColor.accent.color)
                        }
                        Text("created: \(gist.createdAt)")
                            .font(.caption)
                            .foregroundColor(ThemeColor.textCaptionOnBackground.color)
                        Text("updated: \(gist.updatedAt)")
                            .font(.caption)
                            .foregroundColor(ThemeColor.textCaptionOnBackground.color)
                        Text("pushed: \(gist.pushedAt)")
                            .font(.caption)
                            .foregroundColor(ThemeColor.textCaptionOnBackground.color)
                        if !gist.description.isEmpty {
                            Text(gist.description)
                                .font(Font.system(size: 14))
                                .foregroundColor(ThemeColor.textBody1OnBackground.color)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 16)
                        }
                    }
                    Spacer()
                }
                .padding(16)
                Rectangle()
                    .frame(width: 256, height: 0.5)
                    .background(ThemeColor.textSubtitleOnBackground.color)
                Text("Files")
                    .font(Font.headline)
                    .foregroundColor(ThemeColor.textSubtitleOnBackground.color)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                ForEach(gist.files, id: \.name) { gistFile in
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(gistFile.name)
                                    .font(Font.body)
                                    .foregroundColor(ThemeColor.textBody1OnBackground.color)
                                    .bold()
                                    .underline()
                                if gistFile.isImage {
                                    URLImage(url: "https://gist.githubusercontent.com/\(self.gist.owner)/\(self.gist.name)/raw/\(gistFile.encodedName)") // swiftlint:disable:this line_length line_length
                                } else {
                                    Text(gistFile.text ?? "")
                                        .font(Font.body)
                                        .foregroundColor(ThemeColor.textBody2OnBackground.color)
                                }
                            }
                            Spacer()
                        }
                        .padding(16)
                    }.padding(.top, 16)
                }
            }
            .navigationBarTitle("\(gist.files.first?.name ?? "") (\(gist.files.count) files)")
        }
    }
}

struct GistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 11 Pro", "iPhone SE"], id: \.self) { deviceName in
            GistDetailView(viewModel: GistDetailViewModelFactory.makeForPreview())
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
    }
}
