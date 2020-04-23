//
//  GistListView.swift
//  StructurePlayground
//
//  Created by roana0229 on 2020/04/01.
//

import SwiftUI

public struct GistListViewFactory {
    public static func make() -> GistListView {
        GistListView(viewModel: GistListViewModelFactory.make())
    }
}

public struct GistListView: View {
    @ObservedObject var viewModel: GistListViewModel

    init(viewModel: GistListViewModel) {
        self.viewModel = viewModel
        // ListがUITableViewで実装されているため、UITableViewのプロパティを変更してListのdividerを調整する
        UITableView.appearance().tableHeaderView = UIView()
        UITableView.appearance().tableFooterView = UIView()
    }

    public var body: some View {
        NavigationView {
            VStack {
                List {
                    SearchBar(text: $viewModel.searchText)
                    ForEach(
                        $viewModel.searchText.wrappedValue.isEmpty ?
                            $viewModel.gists.wrappedValue :
                            $viewModel.gists.wrappedValue.filter {
                                "\($0.name) \($0.description) \($0.files.map { $0.name }.joined())"
                                    .contains($viewModel.searchText.wrappedValue)
                            },
                        id: \.id
                    ) { gist in
                        NavigationLink(destination: GistDetailViewFactory.make(gist: gist)) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(gist.name)
                                        .font(Font.system(size: 12))
                                        .lineLimit(1)
                                        .foregroundColor(ThemeColor.textCaptionOnBackground.color)
                                    Spacer()
                                    Text("\(gist.files.count) files")
                                        .font(Font.system(size: 12))
                                        .lineLimit(1)
                                        .foregroundColor(ThemeColor.accent.color)
                                }
                                Text(gist.files.first?.name ?? "")
                                    .font(Font.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(ThemeColor.textBody1OnBackground.color)
                                if !gist.description.isEmpty {
                                    Text(gist.description)
                                        .font(Font.system(size: 14))
                                        .foregroundColor(ThemeColor.textBody2OnBackground.color)
                                        .lineLimit(3)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                        }
                    }
                    if $viewModel.canMoreLoading.wrappedValue {
                        HStack {
                            Spacer()
                            ActivityIndicator(isAnimating: $viewModel.isLoading,
                                              style: .medium,
                                              color: ThemeColor.textCaptionOnBackground.uiColor)
                            Spacer()
                        }
                        .onAppear(perform: viewModel.onLoadingAppear)
                        .onDisappear(perform: viewModel.onLoadingDisappear)
                    }
                }
            }
            .navigationBarTitle($viewModel.isSearching.wrappedValue ? "Searching..." : "My Gists")
            .navigationBarItems(trailing:
                HStack(spacing: 16) {
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "globe")
                    }
                    NavigationLink(destination: ProfileViewFactory.make()) {
                        Image(systemName: "person.crop.circle")
                    }
                }
            )
        }
        .accentColor(ThemeColor.primary.color)
        .onAppear(perform: viewModel.onContentAppear)
        .onDisappear(perform: viewModel.onContentDisappear)
    }
}

struct GistListView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 11 Pro", "iPhone SE"], id: \.self) { deviceName in
            GistListView(viewModel: GistListViewModelFactory.makeForPreview())
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
    }
}
