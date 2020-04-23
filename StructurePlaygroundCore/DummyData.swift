//
//  DummyData.swift
//  StructurePlaygroundCore
//
//  Created by roana0229 on 2020/04/16.
//

import Foundation

extension Gist {
    public static func dummyForPreview() -> Gist {
        let name = String(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(32)).lowercased()
        return Gist(cursor: UUID().uuidString,
                    owner: String(dummyTextEN().split(separator: " ").randomElement()!),
                    id: String((UUID().uuidString + UUID().uuidString).prefix(52)),
                    url: "https://gist.github.com/\(name)",
                    createdAt: "2020-03-09T16:08:20Z",
                    updatedAt: "2020-03-10T08:04:50Z",
                    pushedAt: "2020-03-10T08:04:50Z",
                    isPublic: Bool.random(),
                    name: name,
                    description: String(dummyText().prefix(Int.random(in: 32 ... 128))),
                    files: [GistFile.dummyForPreview(), GistFile.dummyForPreview(asImage: true), GistFile.dummyForPreview()])
    }
}

extension GistFile {
    fileprivate static func dummyForPreview(asImage: Bool = false) -> GistFile {
        if asImage {
            return GistFile(name: "dummy.jpg",
                            encodedName: "dummy.jpg",
                            encoding: nil,
                            isImage: true,
                            text: nil)
        } else {
            return GistFile(name: "dummy.md",
                            encodedName: "dummy.md",
                            encoding: "UTF-8",
                            isImage: false,
                            text: dummyText())
        }
    }
}

extension Profile {
    public static func dummyForPreview() -> Profile {
        let login = String(dummyTextEN().split(separator: " ").randomElement()!)
        return Profile(name: dummyTextEN(1),
                       login: login,
                       email: "\(dummyTextEN(2))@example.com",
                       url: "https://github.com/\(login)",
                       avatarUrl: "https://via.placeholder.com/512")
    }
}

private func dummyText() -> String {
    [dummyTextEN(), dummyTextJP()].randomElement()!
}

private func dummyTextEN() -> String {
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eleifend, mi vitae ultricies scelerisque, ex mi hendrerit tortor, vitae gravida velit tellus sed est. Aliquam ut nunc rutrum, congue odio quis, ultrices justo. Aenean sed semper ex. Mauris tincidunt accumsan aliquam. Curabitur nec finibus purus. Integer vel fermentum mauris. Pellentesque consectetur eget ex a facilisis. Sed ultricies quis mi a vestibulum. Sed consectetur quam non nunc blandit mattis. Curabitur congue consequat diam, eget volutpat arcu. Nulla vitae turpis ex. Maecenas elementum felis nunc, porta convallis turpis vulputate nec. Aliquam non nisi id purus vestibulum convallis id in mi. Phasellus et quam justo."
}

private func dummyTextEN(_ wordCount: Int) -> String {
    (0 ..< wordCount).map { _ in String(dummyTextEN().split(separator: " ").randomElement()!) }.joined()
}

private func dummyTextJP() -> String {
    "吾輩は猫である。名前はまだ無い。どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕えて煮て食うという話である。しかしその当時は何という考もなかったから別段恐しいとも思わなかった。ただ彼の掌に載せられてスーと持ち上げられた時何だかフワフワした感じがあったばかりである。掌の上で少し落ちついて書生の顔を見たのがいわゆる人間というものの見始であろう。この時妙なものだと思った感じが今でも残っている。第一毛をもって装飾されべきはずの顔がつるつるしてまるで薬缶だ。その後猫にもだいぶ逢ったがこんな片輪には一度も出会わした事がない。のみならず顔の真中があまりに突起している。"
}
