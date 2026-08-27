import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var player: PlayerManager

    var body: some View {
        BeansNavigationStack {
            Group {
                if player.history.isEmpty {
                    EmptyStateView(icon: "clock.arrow.circlepath", text: "暂无播放历史")
                } else {
                    List {
                        let currentSongID = player.currentSong?.identityKey
                        let isPlaying = player.isPlaying
                        ForEach(Array(player.history.enumerated()), id: \.element.identityKey) { index, song in
                            SongCell(
                                song: song,
                                glassRow: true,
                                isCurrent: currentSongID == song.identityKey,
                                isPlaying: isPlaying,
                                onTap: {
                                    player.play(songs: player.history, startAt: index)
                                },
                                onPlayNext: {
                                    player.playNext(song)
                                }
                            )
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .onDelete { offsets in
                            player.removeHistory(at: offsets)
                        }
                    }
                    .beansScrollContentBackgroundHidden()
                    .listStyle(.plain)
                    .background(LinearGradient.beansBackdrop)
                }
            }
            .navigationTitle("最近播放")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !player.history.isEmpty {
                        Button("清空") {
                            player.clearHistory()
                        }
                    }
                }
            }
        }
    }
}
