import SwiftUI

struct LexiconEntryView: View {
    let unit: String
    let translations: [[String: String]]

    var body: some View {
        List {
            if translations.count > 1 {
                ForEach(0 ..< translations.count, id: \.self) { i in
                    let translation = translations[i]
                    Section(String(i + 1)) {
                        renderTranslation(translation)
                    }
                }
            } else if translations.count == 1 {
                let translation = translations[0]
                renderTranslation(translation)
            }
        }
        .listStyle(.plain)
        .navigationTitle(unit)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func renderTranslation(_ translation: [String: String]) -> some View {
        return ForEach(translation.keys.sorted(), id: \.self) { lang in
            HStack {
                Text(lang)
                    .opacity(0.5)
                Text(translation[lang]!)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

struct LexiconEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LexiconEntryView(unit: "bir", translations: [["en": "child"]])
        }
    }
}
