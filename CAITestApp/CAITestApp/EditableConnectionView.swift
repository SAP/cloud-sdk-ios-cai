import SwiftUI

struct EditableConnectionView: View {
    @ObservedObject var model: Connection
    var body: some View {
        VStack {
            FloatingTextField(title: "Base URL", text: $model.baseURL, placeholder: "https://TENANT_DOMAIN.sapcai.<region>.hana.ondemand.com/public/api")
            FloatingTextField(title: "Auth URL", text: $model.authorizationEndpointURL, placeholder: "https://TENANT_DOMAIN.authentication.<region>.hana.ondemand.com/oauth/authorize")
            FloatingTextField(title: "Token URL", text: $model.tokenEndpointURL, placeholder: "https://TENANT_DOMAIN.authentication.<region>.hana.ondemand.com/oauth/token")
            FloatingTextField(title: "Redirect URL", text: $model.redirectURL, placeholder: "https://TENANT_DOMAIN.authentication.<region>.hana.ondemand.com/login/callback")
            FloatingTextField(title: "Client Id", text: $model.clientId, placeholder: "Client Id")
            FloatingTextField(title: "Client Secret", text: $model.clientSecret, placeholder: "Client Secret")
            FloatingTextField(title: "Developer Token", text: $model.developerToken, placeholder: "Developer Token")

            Button(action: {
                model.saveToUserDefaults()
            }) {
                HStack(spacing: 10) {
                    Spacer()
                    Image(systemName: "square.and.arrow.down")
                    Text("Save")
                }
            }.padding(.top)

        }.padding([.top, .leading, .trailing])
    }
}

struct EditableConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        EditableConnectionView(model: Connection(name: "a", baseURL: "", authorizationEndpointURL: "", tokenEndpointURL: "", redirectURL: "", clientId: "123", clientSecret: "", developerToken: "", channelId: "j", channelToken: "k", channelSlug: "l", conversationId: "m"))
    }
}
