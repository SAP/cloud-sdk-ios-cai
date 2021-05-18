import SwiftUI
import URLImage

struct AvatarView: View {
    var imageUrl: String
    
    var body: some View {
        URLImage(URL(string: imageUrl)!,
                 inProgress: { _ -> Image in
                     Image(systemName: "person.crop.circle")
                 },
                 failure: { error, _ in
                     Text(error.localizedDescription)
                 },
                 content: { image in
                     image
                         .resizable() // Make image resizable
                         .aspectRatio(contentMode: .fill) // Fill the frame
                         .clipped() // Clip overlaping parts
                 })
            .frame(width: 32, height: 32, alignment: .center)
    }
}

#if DEBUG
    struct AvatarView_Previews: PreviewProvider {
        static var previews: some View {
            AvatarView(imageUrl: "https://odesk-prod-portraits.s3.amazonaws.com/Companies:3813315:CompanyLogoURL?AWSAccessKeyId=AKIAIKIUKM3HBSWUGCNQ&Expires=2147483647&Signature=LWzh%2FJ1lzx172eTlTNk2aq1ZvJs%3D")
        }
    }
#endif
