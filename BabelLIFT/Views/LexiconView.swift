import SwiftUI

struct LexiconView: View {
    let name: String
    let lexicon: LIFT

    @State private var searchQuery: String = ""

    var body: some View {
        let entries = getEntries()
        let lexicalUnits =
        (searchQuery == ""
         ? Array(entries.keys)
         : entries.keys
            .filter({ lexicalUnit in
                let lexicalUnitSearch = lexicalUnit.lowercased()
                let searchQuerySearch = searchQuery.lowercased()
                return lexicalUnitSearch.contains(searchQuerySearch)
            }))
        .sorted()

        VStack {
            TextField(text: $searchQuery) {
                Text("Search...")
            }
            .padding(7)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            .toolbar {
                if searchQuery != "" {
                    Button(action: { searchQuery = "" }) {
                        Text("Cancel")
                            .bold()
                    }
                }
            }
            List {
                ForEach(lexicalUnits, id: \.self) { lexicalUnit in
                    let senses = entries[lexicalUnit]!
                    NavigationLink(destination: LexiconEntryView(lexicalUnit: lexicalUnit, senses: senses)) {
                        Text(lexicalUnit)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(name)
            .navigationBarTitleDisplayMode(.inline)
        }
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
