import SwiftUI

struct AvatarView: View {
    var imageUrl: String
    
    var body: some View {
        ImageViewWrapper(url: URL(string: imageUrl),
                         placeholder: { Image(systemName: "person.crop.circle") },
                         failure: { _ in Image(systemName: "person.crop.circle") },
                         content: { $0 })
            .scaledToFill()
            .frame(width: 32, height: 32, alignment: .center)
            .clipped()
    }
}

#if DEBUG
    struct AvatarView_Previews: PreviewProvider {
        static var previews: some View {
            AvatarView(imageUrl: "https://odesk-prod-portraits.s3.amazonaws.com/Companies:3813315:CompanyLogoURL?AWSAccessKeyId=AKIAIKIUKM3HBSWUGCNQ&Expires=2147483647&Signature=LWzh%2FJ1lzx172eTlTNk2aq1ZvJs%3D")
        }
    }
#endif
