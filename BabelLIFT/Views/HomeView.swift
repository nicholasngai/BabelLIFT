import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Import New Lexicon...", destination: ImportLIFTView(onImport: addLexicon))
            }
            .navigationTitle("BabelLIFT")
        }
    }

    private func addLexicon(_ lift: LIFT) {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
