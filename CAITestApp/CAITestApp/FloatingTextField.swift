import SwiftUI

struct FloatingTextField: View {
    let title: String
    let text: Binding<String>
    let placeholder: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.accentColor)
                .scaleEffect(0.75, anchor: .leading)
            TextField(placeholder, text: text).textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct FloatingTextField_Previews: PreviewProvider {
    @State static var text: String = ""
    static var previews: some View {
        VStack {
            FloatingTextField(title: "MyTitle", text: FloatingTextField_Previews.$text, placeholder: "MyTitle")
        }.padding()
    }
}
