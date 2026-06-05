//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

/// Swift bindings for webrtc::CryptoOptions.
public struct CryptoOptions: OptionSet, Hashable, Codable, Sendable {
    public let rawValue: Int8

    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }

    public static var none: CryptoOptions {
        CryptoOptions(rawValue: 0)
    }

    public static var all: CryptoOptions {
        [.gcmCryptoSuites, .aes128Sha1_32CryptoCipher, .encryptedRtpHeaderExtensions, .requireFrameEncryption]
    }

    /// Enable GCM crypto suites from RFC 7714 for SRTP. GCM will only be used if both sides enable it
    public static var gcmCryptoSuites: CryptoOptions {
        CryptoOptions(rawValue: 1 << 0)
    }

    /// If set, the (potentially insecure) crypto cipher kSrtpAes128CmSha1_32 will be included in the list of supported ciphers during negotiation.
    /// It will only be used if both peers support it and no other ciphers get preferred.
    public static var aes128Sha1_32CryptoCipher: CryptoOptions {
        CryptoOptions(rawValue: 1 << 1)
    }

    /// If set, encrypted RTP header extensions as defined in RFC 6904 will be negotiated. They will only be used if both peers support them.
    public static var encryptedRtpHeaderExtensions: CryptoOptions {
        CryptoOptions(rawValue: 1 << 2)
    }

    /// If set all RtpSenders must have an FrameEncryptor attached to them before they are allowed to send packets.
    /// All RtpReceivers must have a FrameDecryptor attached to them before they are able to receive packets.
    public static var requireFrameEncryption: CryptoOptions {
        CryptoOptions(rawValue: 1 << 3)
    }
}

extension CryptoOptions {
    init(options: RTCCryptoOptions) {
        self = [
            options.srtpEnableGcmCryptoSuites ? .gcmCryptoSuites : .none,
            options.srtpEnableAes128Sha1_32CryptoCipher ? .aes128Sha1_32CryptoCipher : .none,
            options.srtpEnableEncryptedRtpHeaderExtensions ? .encryptedRtpHeaderExtensions : .none,
            options.sframeRequireFrameEncryption ? .requireFrameEncryption : .none,
        ]
    }
}

extension RTCCryptoOptions {
    convenience init(options: CryptoOptions) {
        let srtpEnableGcmCryptoSuites = options.contains(.gcmCryptoSuites)
        let srtpEnableAes128Sha1_32CryptoCipher = options.contains(.aes128Sha1_32CryptoCipher)
        let srtpEnableEncryptedRtpHeaderExtensions = options.contains(.encryptedRtpHeaderExtensions)
        let sframeRequireFrameEncryption = options.contains(.requireFrameEncryption)

        self.init(srtpEnableGcmCryptoSuites: srtpEnableGcmCryptoSuites,
                  srtpEnableAes128Sha1_32CryptoCipher: srtpEnableAes128Sha1_32CryptoCipher,
                  srtpEnableEncryptedRtpHeaderExtensions: srtpEnableEncryptedRtpHeaderExtensions,
                  sframeRequireFrameEncryption: sframeRequireFrameEncryption)
    }
}
