//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

public struct Configuration {
    /// If true, allows DSCP codes to be set on outgoing packets, configured using networkPriority field of RTCRtpEncodingParameters. Defaults to false.
    public var enableDscp: Bool

    ///  An array of Ice Servers available to be used by ICE.
    public var iceServers: [IceServer]

    ///  An Certificate for 're' use.
    public var certificate: Certificate?

    ///  Which candidates the ICE agent is allowed to use. The W3C calls it `iceTransportPolicy`, while in C++ it is called `type`.
    public var iceTransportPolicy: IceTransportPolicy

    ///  The media-bundling policy to use when gathering ICE candidates.
    public var bundlePolicy: BundlePolicy

    ///  The rtcp-mux policy to use when gathering ICE candidates.
    public var rtcpMuxPolicy: RtcpMuxPolicy

    public var tcpCandidatePolicy: TcpCandidatePolicy

    public var candidateNetworkPolicy: CandidateNetworkPolicy

    public var continualGatheringPolicy: ContinualGatheringPolicy

    /**  If set to YES, don't gather IPv6 ICE candidates on Wi-Fi.
     *  Only intended to be used on specific devices. Certain phones disable IPv6
     *  when the screen is turned off and it would be better to just disable the
     *  IPv6 ICE candidates on Wi-Fi in those cases.
     *  Default is false.
     */
    public var disableIPV6OnWiFi: Bool

    /**  By default, the PeerConnection will use a limited number of IPv6 network
     *  interfaces, in order to avoid too many ICE candidate pairs being created
     *  and delaying ICE completion.
     *
     *  Can be set to INT_MAX to effectively disable the limit.
     */
    public var maxIPv6Networks: Int32

    /// Exclude link-local network interfaces from considertaion for gathering ICE candidates.
    /// Defaults to false.
    public var disableLinkLocalNetworks: Bool

    public var audioJitterBufferMaxPackets: Int32

    public var audioJitterBufferFastAccelerate: Bool

    public var iceConnectionReceivingTimeout: Int32

    public var iceBackupCandidatePairPingInterval: Int32

    ///  Key type used to generate SSL identity. Default is ECDSA.
    public var keyType: EncryptionKeyType

    ///  ICE candidate pool size as defined in JSEP. Default is 0.
    public var iceCandidatePoolSize: Int32

    /// Prune turn ports on the same network to the same turn server.
    /// Default is false.
    public var shouldPruneTurnPorts: Bool

    /// If set to true, this means the ICE transport should presume TURN-to-TURN candidate pairs will succeed, even before a binding response is received.
    public var shouldPresumeWritableWhenFullyRelayed: Bool

    public var shouldSurfaceIceCandidatesOnIceTransportTypeChanged: Bool

    /// If set to non-nil, controls the minimal interval between consecutive ICE check packets.
    public var iceCheckMinInterval: NSNumber?

    /**
     * Configure the SDP semantics used by this PeerConnection. By default, this
     * is RTCSdpSemanticsUnifiedPlan which is compliant to the WebRTC 1.0
     * specification. It is possible to overrwite this to the deprecated
     * RTCSdpSemanticsPlanB SDP format, but note that RTCSdpSemanticsPlanB will be
     * deleted at some future date, see  [](https://crbug.com/webrtc/13528).
     *
     * RTCSdpSemanticsUnifiedPlan will cause RTCPeerConnection to create offers and
     * answers with multiple m= sections where each m= section maps to one
     * RTCRtpSender and one RTCRtpReceiver (an RTCRtpTransceiver), either both audio
     * or both video. This will also cause RTCPeerConnection to ignore all but the
     * first a=ssrc lines that form a Plan B stream.
     *
     * RTCSdpSemanticsPlanB will cause RTCPeerConnection to create offers and
     * answers with at most one audio and one video m= section with multiple
     * RTCRtpSenders and RTCRtpReceivers specified as multiple a=ssrc lines within
     * the section. This will also cause RTCPeerConnection to ignore all but the
     * first m= section of the same media type.
     */
    public var sdpSemantics: SdpSemantics

    /**  Actively reset the SRTP parameters when the DTLS transports underneath are
     *  changed after offer/answer negotiation. This is only intended to be a
     *  workaround for crbug.com/835958
     */
    public var activeResetSrtpParams: Bool

    /**
     * Defines advanced optional cryptographic settings related to SRTP and
     * frame encryption for native WebRTC. Setting this will overwrite any
     * options set through the PeerConnectionFactory (which is deprecated).
     */
    public var cryptoOptions: CryptoOptions?

    /**
     * An optional string that will be attached to the TURN_ALLOCATE_REQUEST which
     * which can be used to correlate client logs with backend logs.
     */
    public var turnLoggingId: String?

    /// Time interval between audio RTCP reports.
    public var rtcpAudioReportIntervalMs: Int32

    /// Time interval between video RTCP reports.
    public var rtcpVideoReportIntervalMs: Int32

    /**
     * Allow implicit rollback of local description when remote description
     * conflicts with local description.
     * - See: [](https://w3c.github.io/webrtc-pc/#dom-peerconnection-setremotedescription)
     */
    public var enableImplicitRollback: Bool

    /**
     * Control if "a=extmap-allow-mixed" is included in the offer.
     * - See: [](https://www.chromestatus.com/feature/6269234631933952)
     */
    public var offerExtmapAllowMixed: Bool

    /**
     * Defines the interval applied to ALL candidate pairs
     * when ICE is strongly connected, and it overrides the
     * default value of this interval in the ICE implementation;
     */
    public var iceCheckIntervalStrongConnectivity: NSNumber?

    /**
     * Defines the counterpart for ALL pairs when ICE is
     * weakly connected, and it overrides the default value of
     * this interval in the ICE implementation
     */
    public var iceCheckIntervalWeakConnectivity: NSNumber?

    /**
     * The min time period for which a candidate pair must wait for response to
     * connectivity checks before it becomes unwritable. This parameter
     * overrides the default value in the ICE implementation if set.
     */
    public var iceUnwritableTimeout: NSNumber?

    /**
     * The min number of connectivity checks that a candidate pair must sent
     * without receiving response before it becomes unwritable. This parameter
     * overrides the default value in the ICE implementation if set.
     */
    public var iceUnwritableMinChecks: NSNumber?

    /**
     * The min time period for which a candidate pair must wait for response to
     * connectivity checks it becomes inactive. This parameter overrides the
     * default value in the ICE implementation if set.
     */
    public var iceInactiveTimeout: NSNumber?
}

public extension Configuration {
    init() {
        self.init(RTCConfiguration())
    }
}

extension Configuration {
    init(_ config: RTCConfiguration) {
        self.init(enableDscp: config.enableDscp,
                  iceServers: config.iceServers.map { IceServer(server: $0) },
                  iceTransportPolicy: .init(config.iceTransportPolicy),
                  bundlePolicy: .init(config.bundlePolicy),
                  rtcpMuxPolicy: .init(config.rtcpMuxPolicy),
                  tcpCandidatePolicy: .init(config.tcpCandidatePolicy),
                  candidateNetworkPolicy: .init(config.candidateNetworkPolicy),
                  continualGatheringPolicy: .init(config.continualGatheringPolicy),
                  disableIPV6OnWiFi: config.disableIPV6OnWiFi,
                  maxIPv6Networks: config.maxIPv6Networks,
                  disableLinkLocalNetworks: config.disableLinkLocalNetworks,
                  audioJitterBufferMaxPackets: config.audioJitterBufferMaxPackets,
                  audioJitterBufferFastAccelerate: config.audioJitterBufferFastAccelerate,
                  iceConnectionReceivingTimeout: config.iceConnectionReceivingTimeout,
                  iceBackupCandidatePairPingInterval: config.iceBackupCandidatePairPingInterval,
                  keyType: .init(config.keyType),
                  iceCandidatePoolSize: config.iceCandidatePoolSize,
                  shouldPruneTurnPorts: config.shouldPruneTurnPorts,
                  shouldPresumeWritableWhenFullyRelayed: config.shouldPresumeWritableWhenFullyRelayed,
                  shouldSurfaceIceCandidatesOnIceTransportTypeChanged: config.shouldSurfaceIceCandidatesOnIceTransportTypeChanged,
                  sdpSemantics: .init(config.sdpSemantics),
                  activeResetSrtpParams: config.activeResetSrtpParams,
                  rtcpAudioReportIntervalMs: config.rtcpAudioReportIntervalMs,
                  rtcpVideoReportIntervalMs: config.rtcpVideoReportIntervalMs,
                  enableImplicitRollback: config.enableImplicitRollback,
                  offerExtmapAllowMixed: config.offerExtmapAllowMixed)
    }
}

extension RTCConfiguration {
    convenience init(_ config: Configuration) {
        self.init()

        enableDscp = config.enableDscp
        iceServers = config.iceServers.map(\.server)
        iceTransportPolicy = .init(config.iceTransportPolicy)
        bundlePolicy = .init(config.bundlePolicy)
        rtcpMuxPolicy = .init(config.rtcpMuxPolicy)
        tcpCandidatePolicy = .init(config.tcpCandidatePolicy)
        candidateNetworkPolicy = .init(config.candidateNetworkPolicy)
        continualGatheringPolicy = .init(config.continualGatheringPolicy)
        disableIPV6OnWiFi = config.disableIPV6OnWiFi
        maxIPv6Networks = config.maxIPv6Networks
        disableLinkLocalNetworks = config.disableLinkLocalNetworks
        audioJitterBufferMaxPackets = config.audioJitterBufferMaxPackets
        audioJitterBufferFastAccelerate = config.audioJitterBufferFastAccelerate
        iceConnectionReceivingTimeout = config.iceConnectionReceivingTimeout
        iceBackupCandidatePairPingInterval = config.iceBackupCandidatePairPingInterval
        keyType = .init(config.keyType)
        iceCandidatePoolSize = config.iceCandidatePoolSize
        shouldPruneTurnPorts = config.shouldPruneTurnPorts
        shouldPresumeWritableWhenFullyRelayed = config.shouldPresumeWritableWhenFullyRelayed
        shouldSurfaceIceCandidatesOnIceTransportTypeChanged = config.shouldSurfaceIceCandidatesOnIceTransportTypeChanged
        sdpSemantics = .init(config.sdpSemantics)
        activeResetSrtpParams = config.activeResetSrtpParams
        rtcpAudioReportIntervalMs = config.rtcpAudioReportIntervalMs
        rtcpVideoReportIntervalMs = config.rtcpVideoReportIntervalMs
        enableImplicitRollback = config.enableImplicitRollback
        offerExtmapAllowMixed = config.offerExtmapAllowMixed
    }
}
