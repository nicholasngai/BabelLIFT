import SwiftUI

struct ImportLIFTView: View {
    let onImport: (_ lift: LIFT) -> Void

    @State private var name = ""
    @State private var lift: LIFT? = nil
    @State private var liftFilename: String? = nil
    @State private var isShowingFileImporter = false

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Name")
                    TextField("Lexicon name", text: $name)
                }
                HStack {
                    Button(action: { isShowingFileImporter.toggle(); print(isShowingFileImporter) }) {
                        Text("Select file...")
                    }
                    if liftFilename != nil {
                        Text(liftFilename!)
                    }
                }
            }
            .navigationTitle("Import New")
        }
        .toolbar {
            Button(role: .destructive, action: handleDone) {
                Text("Done")
                    .bold()
            }
            .disabled(name == "" || lift == nil)
        }
        // TODO Restrict to .lift.
        .fileImporter(isPresented: $isShowingFileImporter, allowedContentTypes: [.item], onCompletion:handleLoadLift)
    }

    private func handleLoadLift(result: Result<URL, Error>) {
        do {
            let url = try result.get()
            assert(url.startAccessingSecurityScopedResource())
            let data = try Data(contentsOf: url)
            let liftParser = LIFTParser(data: data)
            liftParser.parse()
            lift = liftParser.getParsed()
            liftFilename = url.lastPathComponent
        } catch {
            print(error)
        }
    }

    private func handleDone() {
        onImport(lift!)
        presentationMode.wrappedValue.dismiss()
    }
}

struct ImportLIFTView_Previews: PreviewProvider {
    static var previews: some View {
        ImportLIFTView(onImport: { lift in })
    }
}
