import SwiftUI

struct LexiconEntryView: View {
    let lexicalUnit: String
    let senses: [[String: String]]

    var body: some View {
        List {
            if senses.count > 1 {
                ForEach(0 ..< senses.count, id: \.self) { i in
                    let sense = senses[i]
                    Section(String(i + 1)) {
                        renderSense(sense)
                    }
                }
            } else if senses.count == 1 {
                let sense = senses[0]
                renderSense(sense)
            }
        }
        .listStyle(.plain)
        .navigationTitle(lexicalUnit)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func renderSense(_ sense: [String: String]) -> some View {
        return ForEach(sense.keys.sorted(), id: \.self) { lang in
            HStack {
                Text(lang)
                    .opacity(0.5)
                Text(sense[lang]!)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

struct LexiconEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LexiconEntryView(lexicalUnit: "bir", senses: [["en": "child"]])
        }
    }
}
