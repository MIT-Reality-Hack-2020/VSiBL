//
//  ARViewController.swift
//  VSiBL Prototype
//
//  Created by User239 on 1/18/20.
//  Copyright © 2020 VSiBL. All rights reserved.
//

// Part of this code has been obtained from Apple's sample project: https://developer.apple.com/documentation/arkit/creating_a_collaborative_session
// License for Apple sample code:

/*
 
 Copyright © 2019 Apple Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit
import RealityKit
import ARKit

class ARViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    // Properties
    var multipeerSession: MultipeerSession?
    var sessionIDObservation: NSKeyValueObservation?
    
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true // Prevent the screen from being dimmed to avoid interrupting the AR experience.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupARView()
        setupMultipeerSession()
    }
    
    override var prefersStatusBarHidden: Bool {
        // Request that iOS hide the status bar to improve immersiveness of the AR experience.
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        // Request that iOS hide the home indicator to improve immersiveness of the AR experience.
        return true
    }
    
    // MARK: - Setup Methods
    
    private func setupARView() {
        arView.automaticallyConfigureSession = false
        arView.session.delegate = self
        
        let config = ARWorldTrackingConfiguration()
        config.isCollaborationEnabled = true
        config.planeDetection = [.horizontal, .vertical]
        
        arView.session.run(config)
    }
    
    private func setupMultipeerSession() {
        // Use key-value observation to monitor your ARSession's identifier.
        sessionIDObservation = observe(\.arView.session.identifier, options: [.new]) { object, change in
            print("SessionID changed to: \(change.newValue!)")
            // Tell all other peers about your ARSession's changed ID, so
            // that they can keep track of which ARAnchors are yours.
            guard let multipeerSession = self.multipeerSession else { return }
            self.sendARSessionIDTo(peers: multipeerSession.connectedPeers)
        }
                
        // Start looking for other players via MultiPeerConnectivity.
        multipeerSession = MultipeerSession(serviceType: "vsibl-rh2020",
                                            receivedDataHandler: receivedData,
                                            peerJoinedHandler: peerJoined,
                                            peerLeftHandler: peerLeft,
                                            peerDiscoveredHandler: peerDiscovered)
    }
}

extension ARViewController: ARSessionDelegate {
    func session(_ session: ARSession, didOutputCollaborationData data: ARSession.CollaborationData) {
        guard let multipeerSession = multipeerSession else { return }
        if !multipeerSession.connectedPeers.isEmpty {
            guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            else { fatalError("Unexpectedly failed to encode collaboration data.") }
            // Use reliable mode if the data is critical, and unreliable mode if the data is optional.
            let dataIsCritical = data.priority == .critical
            multipeerSession.sendToAllPeers(encodedData, reliably: dataIsCritical)
        } else {
            print("Deferred sending collaboration to later because there are no peers.")
        }
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let participantAnchor = anchor as? ARParticipantAnchor {
                print("Established joint experience with a peer.")
                
                let mesh = MeshResource.generateSphere(radius: 0.07)
                let color = UIColor.cyan
                let material = UnlitMaterial(color: color)
                let userAvatar = ModelEntity(mesh: mesh, materials: [material])
                
                userAvatar.position = [0, -0.4, 0.4] // TODO FIX: Hacky - Needs to be more elegant (e.g. joint or face detection to offset position)
                
                let anchorEntity = AnchorEntity(anchor: participantAnchor)
                anchorEntity.addChild(userAvatar)
                
                arView.scene.addAnchor(anchorEntity)
            }
        }
    }
}
