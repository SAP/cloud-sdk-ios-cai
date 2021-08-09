import SwiftUI

struct AvatarView: View {
    var imageUrl: String
    
    var body: some View {
        if let url = URL(string: imageUrl) {
            ImageViewWrapper(url: url) { $0 }
                .scaledToFill()
                .placeholder(Image(systemName: "person.crop.circle"))
                .frame(width: 32, height: 32, alignment: .center)
                .clipped()
        } else {
            Image(systemName: "icloud.slash")
        }
    }
}

#if DEBUG
    struct AvatarView_Previews: PreviewProvider {
        static var previews: some View {
            AvatarView(imageUrl: "https://odesk-prod-portraits.s3.amazonaws.com/Companies:3813315:CompanyLogoURL?AWSAccessKeyId=AKIAIKIUKM3HBSWUGCNQ&Expires=2147483647&Signature=LWzh%2FJ1lzx172eTlTNk2aq1ZvJs%3D")
        }
    }
#endif
