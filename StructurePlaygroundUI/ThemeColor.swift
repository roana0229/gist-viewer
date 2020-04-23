//
//  ThemeColor.swift
//  StructurePlayground
//
//  Created by roana0229 on 2020/04/20.
//

import SwiftUI

public enum ThemeColor: String, CaseIterable, Identifiable {
    case primary
    case accent
    case background
    case textOnPrimary = "text-on-primary"
    case textOnAccent = "text-on-accent"
    case textHeadlineOnBackground = "text-headline-on-background"
    case textSubtitleOnBackground = "text-subtitle-on-background"
    case textBody1OnBackground = "text-body1-on-background"
    case textBody2OnBackground = "text-body2-on-background"
    case textCaptionOnBackground = "text-caption-on-background"

    public var id: String { rawValue } // swiftlint:disable:this identifier_name
    var color: Color { Color(rawValue) }
    var uiColor: UIColor { UIColor(named: rawValue)! }

    public static func setup() {
        UITableViewCell.appearance().backgroundColor = ThemeColor.background.uiColor
        UITableView.appearance().backgroundColor = ThemeColor.background.uiColor
        UIScrollView.appearance().backgroundColor = ThemeColor.background.uiColor
        UINavigationBar.appearance().backgroundColor = ThemeColor.background.uiColor
        UINavigationBar.appearance().tintColor = ThemeColor.primary.uiColor
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: ThemeColor.textHeadlineOnBackground.uiColor,
            .font: UIFont(name: "HelveticaNeue-Bold", size: 32)!,
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: ThemeColor.textSubtitleOnBackground.uiColor,
            .font: UIFont(name: "HelveticaNeue-Light", size: 18)!,
        ]
    }
}
