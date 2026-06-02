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
            Form {
                Section("Master") {
                    PeerConnectionStatusInfo(connection: local.masterCoordinator.connection)
                }

                Section {
                    Button("Offer") {
                        Task {
                            try await local.masterCoordinator.offer()
                        }
                    }

                    Button("Answer") {
                        Task {
                            try await local.masterCoordinator.answer()
                        }
                    }
                }
            }

            Form {
                Section("Secondary") {
                    PeerConnectionStatusInfo(connection: local.secondaryCoordinator.connection)
                }

                Section {
                    Button("Offer") {
                        Task {
                            try await local.secondaryCoordinator.offer()
                        }
                    }

                    Button("Answer") {
                        Task {
                            try await local.secondaryCoordinator.answer()
                        }
                    }
                }
            }
        }
    }
}
