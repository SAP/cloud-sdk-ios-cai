import SwiftUI

struct TruncableText: View {
    let text: Text
    let lineLimit: Int?
    @State private var intrinsicSize: CGSize = .zero
    @State private var truncatedSize: CGSize = .zero
    let isTruncatedUpdate: (_ isTruncated: Bool) -> Void
    
    var body: some View {
        text
            .lineLimit(lineLimit)
            .truncationMode(.tail)
            .multilineTextAlignment(.leading)
            .font(.body)
            .fixedSize(horizontal: false, vertical: true)
            .readSize { size in
                truncatedSize = size
                isTruncatedUpdate(truncatedSize != intrinsicSize)
            }
            .background(
                text
                    .fixedSize(horizontal: false, vertical: true)
                    .readSize { size in
                        intrinsicSize = size
                        isTruncatedUpdate(truncatedSize != intrinsicSize)
                    }
                    .hidden()
            )
    }
}
