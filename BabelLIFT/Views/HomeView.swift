import SwiftUI

struct HomeView: View {
    @State private var lexicons: [(name: String, lexicon: LIFT)] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(lexicons, id: \.name) { pair in
                    let (name, lexicon) = pair
                    Text(name)
                }
                NavigationLink("Import New Lexicon...", destination: ImportLIFTView(onImport: addLexicon))
            }
            .navigationTitle("BabelLIFT")
        }
    }

    private func addLexicon(_ name: String, _ lift: LIFT) {
        lexicons.append((name: name, lexicon: lift))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
