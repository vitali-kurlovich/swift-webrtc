//
//  Created by Kurlovich Vitali on 6/1/26.
//

import WebRTC

/** Options  for generating offers and answers. */
public struct PeerMediaOption: OptionSet, Hashable, Codable, Sendable {
    public let rawValue: Int8

    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }

    public static var iceRestart: Self {
        .init(rawValue: 1 << 0)
    }

    public static var offerToReceiveAudio: Self {
        .init(rawValue: 1 << 1)
    }

    public static var offerToReceiveVideo: Self {
        .init(rawValue: 1 << 2)
    }

    public static var voiceActivityDetection: Self {
        .init(rawValue: 1 << 3)
    }

    /// Define media constraints. DtlsSrtpKeyAgreement is required to be true to be able to connect with web browsers.
    public static var tlsSrtp: Self {
        .init(rawValue: 1 << 4)
    }

    //
}

extension PeerMediaOption {
    var dict: [String: String]? {
        if self == [] {
            return nil
        }
        var result: [String: String] = [:]

        if contains(.iceRestart) {
            result[kRTCMediaConstraintsIceRestart] = kRTCMediaConstraintsValueTrue
        }

        if contains(.offerToReceiveAudio) {
            result[kRTCMediaConstraintsOfferToReceiveAudio] = kRTCMediaConstraintsValueTrue
        }

        if contains(.offerToReceiveVideo) {
            result[kRTCMediaConstraintsOfferToReceiveVideo] = kRTCMediaConstraintsValueTrue
        }

        if contains(.voiceActivityDetection) {
            result[kRTCMediaConstraintsVoiceActivityDetection] = kRTCMediaConstraintsValueTrue
        }

        if contains(.tlsSrtp) {
            result["DtlsSrtpKeyAgreement"] = kRTCMediaConstraintsValueTrue
        }

        return result
    }
}
