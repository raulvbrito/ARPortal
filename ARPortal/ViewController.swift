//
//  ViewController.swift
//  ARPortal
//
//  Created by Raul Brito on 26/06/19.
//  Copyright © 2019 Raul Brito. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var portalNode: SCNNode?
    var isPortalPlaced = false
    var debugPlanes: [SCNNode] = []
	
    let positionY: CGFloat = -0.25
    let positionZ: CGFloat = 0
	let doorWidth: CGFloat = 1.0
	let doorHeight: CGFloat = 2.4
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        runSession()
    }
	
    func runSession() {
    	let configuration = ARWorldTrackingConfiguration()
    	configuration.planeDetection = .horizontal
		
    	sceneView.session.run(configuration, options: [.removeExistingAnchors])
    	sceneView.debugOptions = [.renderAsWireframe, .showFeaturePoints]
    	sceneView.delegate = self
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
