import SwiftUI

struct LexiconView: View {
    let name: String
    let lexicon: LIFT

    var body: some View {
        let entries = getEntries()
        let lexicalUnits = entries.keys.sorted()

        List {
            ForEach(lexicalUnits, id: \.self) { lexicalUnit in
                Text(lexicalUnit)
            }
        }
        .listStyle(.plain)
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func getEntries() -> [String: [[String: String]]] {
        var entries: [String: [[String: String]]] = [:]
        for entry in lexicon.entries {
            for lexicalUnit in entry.lexicalUnits.values {
                if entries[lexicalUnit] == nil {
                    entries[lexicalUnit] = []
                }
                entries[lexicalUnit]!.append(entry.senses)
            }
        }
        return entries
    }

    private func getReverseEntries() -> [String: [[String: String]]] {
        var reverseEntries: [String: [[String: String]]] = [:]
        for entry in lexicon.entries {
            for sense in entry.senses.values {
                if reverseEntries[sense] == nil {
                    reverseEntries[sense] = []
                }
                reverseEntries[sense]!.append(entry.lexicalUnits)
            }
        }
        return reverseEntries
    }
}

struct LexiconView_Previews: PreviewProvider {
    static let lexicon = LIFT(
        entries: [
            LIFTEntry(
                lexicalUnits: ["lob-Latn": "bir"],
                senses: ["en": "child"]
            )
        ]
    )

    static var previews: some View {
        NavigationView {
            LexiconView(name: "Lobi", lexicon: lexicon)
        }
    }
}
