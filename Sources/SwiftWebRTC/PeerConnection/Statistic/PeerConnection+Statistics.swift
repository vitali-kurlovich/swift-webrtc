//
//  Created by Kurlovich Vitali on 6/4/26.
//

import WebRTC

public extension PeerConnection {
    /**  Gather stats for the given RTCMediaStreamTrack. If `mediaStreamTrack` is
     * nil statistics are gathered for all tracks.
     */
    func stats(for mediaStreamTrack: RTCMediaStreamTrack?, statsOutputLevel level: StatsOutputLevel) async -> [LegacyStatsReport] {
        let reports = await peerConnection.stats(for: mediaStreamTrack, statsOutputLevel: .init(level))

        return reports.map { LegacyStatsReport($0) }
    }

    /**  Gather statistic through the v2 statistics API. */
    func statistics() async -> StatisticsReport {
        await StatisticsReport(peerConnection.statistics())
    }

    /**  Spec-compliant getStats() performing the stats selection algorithm with the
     *  sender.
     */
    func statistics(for sender: RTCRtpSender) async -> StatisticsReport {
        await StatisticsReport(peerConnection.statistics(for: sender))
    }

    /**  Spec-compliant getStats() performing the stats selection algorithm with the
     *  receiver.
     */
    func statistics(for receiver: RTCRtpReceiver) async -> StatisticsReport {
        await StatisticsReport(peerConnection.statistics(for: receiver))
    }
}
