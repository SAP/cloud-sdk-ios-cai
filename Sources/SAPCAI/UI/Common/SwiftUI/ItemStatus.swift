import SwiftUI

struct ItemStatus: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let status: ValueData
    
    var body: some View {
        if let statusText = status.value {
            if status.valState == .success {
                Text(statusText)
                    .font(.subheadline)
                    .foregroundColor(themeManager.color(for: .successColor))
            } else if status.valState == .error {
                Text(statusText)
                    .font(.subheadline)
                    .foregroundColor(themeManager.color(for: .errorColor))
            } else if status.valState == .warn {
                Text(statusText)
                    .font(.subheadline)
                    .foregroundColor(themeManager.color(for: .warnColor))
            } else if status.valState == .info {
                Text(statusText)
                    .font(.subheadline)
                    .foregroundColor(themeManager.color(for: .infoColor))
            } else {
                Text(statusText)
                    .font(.subheadline)
                    .foregroundColor(themeManager.color(for: .primary2))
            }
        } else {
            EmptyView()
        }
    }
}

struct ItemStatus_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ItemStatus(status: UIModelDataValue(value: "success",
                                                dataType: "text",
                                                rawValue: "status",
                                                label: "stat",
                                                valueState: "success"))
            ItemStatus(status: UIModelDataValue(value: "error",
                                                dataType: "text",
                                                rawValue: "status",
                                                label: "stat",
                                                valueState: "error"))
            ItemStatus(status: UIModelDataValue(value: "warn",
                                                dataType: "text",
                                                rawValue: "status",
                                                label: "stat",
                                                valueState: "warn"))
            ItemStatus(status: UIModelDataValue(value: "info",
                                                dataType: "text",
                                                rawValue: "status",
                                                label: "stat",
                                                valueState: "info"))
            ItemStatus(status: UIModelDataValue(value: "else",
                                                dataType: "text",
                                                rawValue: "status",
                                                label: "stat",
                                                valueState: "else"))
        }
        .environmentObject(ThemeManager.shared)
        .previewLayout(.sizeThatFits)
    }
}
