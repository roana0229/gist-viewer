//
//  ProfileView.swift
//  StructurePlayground
//
//  Created by roana0229 on 2020/04/14.
//

import StructurePlaygroundCore
import SwiftUI

struct ProfileViewFactory {
    public static func make() -> ProfileView {
        ProfileView(viewModel: ProfileViewModelFactory.make())
    }
}

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        guard let profile = viewModel.profile else {
            return AnyView(
                ZStack {
                    ThemeColor.textCaptionOnBackground.color.colorInvert().edgesIgnoringSafeArea(.bottom).opacity(0.8)
                    ActivityIndicator(isAnimating: $viewModel.isLoading,
                                      style: .large,
                                      color: ThemeColor.textCaptionOnBackground.uiColor)
                }
                .navigationBarTitle("Profile")
                .onAppear(perform: viewModel.onLoadingAppear)
                .onDisappear(perform: viewModel.onLoadingDisappear)
            )
        }

        return AnyView(
            ContentView(profile: profile)
                .navigationBarTitle("Profile")
                .onAppear(perform: viewModel.onContentAppear)
                .onDisappear(perform: viewModel.onContentDisappear)
        )
    }

    private struct ContentView: View {
        let profile: Profile

        var body: some View {
            ZStack {
                ThemeColor.background.color.edgesIgnoringSafeArea(.all)
                VStack(spacing: 8) {
                    URLImage(url: profile.avatarUrl)
                        .frame(width: 128, height: 128, alignment: .center)
                        .cornerRadius(64)
                        .padding(.top, 48)
                    Button(profile.login) {
                        if let url = URL(string: self.profile.url) {
                            UIApplication.shared.open(url, options: [:])
                        }
                    }.accentColor(ThemeColor.accent.color)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("name: ")
                                .foregroundColor(ThemeColor.textCaptionOnBackground.color)
                            Text(profile.name)
                                .foregroundColor(ThemeColor.textBody1OnBackground.color)
                        }
                        HStack {
                            Text("email: ")
                                .foregroundColor(ThemeColor.textCaptionOnBackground.color)
                            Text(profile.email)
                                .foregroundColor(ThemeColor.textBody1OnBackground.color)
                        }
                    }.padding(.top, 8)
                    Spacer()
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 11 Pro", "iPhone SE"], id: \.self) { deviceName in
            ProfileView(viewModel: ProfileViewModelFactory.makeForPreview())
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
    }
}
