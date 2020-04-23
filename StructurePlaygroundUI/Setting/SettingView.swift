//
//  SettingView.swift
//  StructurePlayground
//
//  Created by roana0229 on 2020/04/20.
//

import SwiftUI

struct SettingView: View {
    @State private var isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark

    var body: some View {
        ZStack {
            ThemeColor.background.color.edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                Toggle("Dark Mode", isOn: self.$isDarkMode)
                    .padding(.bottom, 4)
                    .foregroundColor(ThemeColor.textBody1OnBackground.color)
                ForEach(ThemeColor.allCases) { item in
                    HStack {
                        Text("\(item.rawValue)")
                            .foregroundColor(ThemeColor.textBody1OnBackground.color)
                        Spacer()
                        item.color
                            .frame(width: 32, height: 32)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(ThemeColor.textBody1OnBackground.color, lineWidth: 1)
                            )
                    }
                }
                Spacer()
            }.padding(16)
        }.navigationBarTitle("Theme Setting")
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
