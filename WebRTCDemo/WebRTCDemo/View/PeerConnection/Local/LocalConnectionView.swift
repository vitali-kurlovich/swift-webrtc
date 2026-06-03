//
//  LocalConnectionView.swift
//  WebRTCDemo
//
//  Created by Kurlovich Vitali on 6/3/26.
//

import Logging
import SwiftUI
import SwiftWebRTC

struct LocalConnectionView: View {
    let local: LocalServerConnection

    var body: some View {
        HStack {
            PeerCoordinatorView(title: "Master", coordinator: local.masterCoordinator)

            PeerCoordinatorView(title: "Secondary", coordinator: local.secondaryCoordinator)
        }
    }
}
