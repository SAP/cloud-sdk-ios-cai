import Combine
import SAPCAI
import SwiftUI

public struct ChannelListView: View {
    @EnvironmentObject private var dataModel: DataModel
    
    @ObservedObject public var channelService: CAIChannelService
    
    @State private var searchText: String = "DemoMobileBot"
    
    public init(_ channelService: CAIChannelService, searchText: String = "") {
        self.channelService = channelService
        self.searchText = searchText
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            SearchBar("Search Application ID", text: self.$searchText) {
                self.channelService.loadChannels(for: self.searchText)
            }
            
            List(channelService.channels) { channel in
                NavigationLink(destination: AssistantView()
                    .navigationBarTitle(Text(channel.slug), displayMode: .inline)
                    .environmentObject(self.dataModel.getModelFor(channel, self.channelService))
                    .environmentObject(ThemeManager.shared)
                    ) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(channel.slug)
                        Text(channel.id)
                    }
                }
            }
        }
        .navigationBarTitle(Text("List"), displayMode: .inline)
        .onAppear {
            if !self.searchText.isEmpty {
                self.channelService.loadChannels(for: self.searchText)
            }
        }
    }
}
