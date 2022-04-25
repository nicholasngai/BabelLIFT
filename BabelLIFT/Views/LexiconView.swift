//
//  LexiconView.swift
//  BabelLIFT
//
//  Created by Nicholas Ngai on 4/25/22.
//

import SwiftUI

private struct LexiconEntry {
    let lexicalUnit: String
    let senses: [String: String]
}

private struct ReverseLexiconEntry {
    let sense: String
    let lexicalUnits: [String: String]
}

struct LexiconView: View {
    let name: String
    let lexicon: LIFT

    var body: some View {
        let entries = getEntries()

        NavigationView {
            List {
                ForEach(entries, id: \.lexicalUnit) { entry in
                    Text(entry.lexicalUnit)
                }
            }
            .navigationTitle(name)
            .listStyle(.plain)
        }
    }

    private func getEntries() -> [LexiconEntry] {
        lexicon.entries
            .flatMap({ entry in
                entry.lexicalUnits.map({ _, lexicalUnit in
                    LexiconEntry(lexicalUnit: lexicalUnit, senses: entry.senses)
                })
            })
            .sorted(by: { a, b in
                a.lexicalUnit <= b.lexicalUnit
            })
    }

    private func getReverseEntries() -> [ReverseLexiconEntry] {
        lexicon.entries
            .flatMap({ entry in
                entry.senses.map({ _, sense in
                    ReverseLexiconEntry(sense: sense, lexicalUnits: entry.lexicalUnits)
                })
            })
            .sorted(by: { a, b in
                a.sense <= b.sense
            })
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
        LexiconView(name: "Lobi", lexicon: lexicon)
    }
}
