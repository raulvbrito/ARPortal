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

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
	@IBOutlet weak var crosshairView: UIView!
	
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
    	configuration.isLightEstimationEnabled = true
		
    	sceneView.session.run(configuration, options: [.removeExistingAnchors])
    	sceneView.debugOptions = [.showFeaturePoints]
    	sceneView.delegate = self
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
	
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let hitTest = self.sceneView.hitTest(self.view.center, types: .existingPlaneUsingExtent).first {
			sceneView.session.add(anchor: ARAnchor(transform: hitTest.worldTransform))
		}
	}

   	func createPlaneNode(center: vector_float3, extent: vector_float3) -> SCNNode {
   		let plane = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
		
		let planeMaterial = SCNMaterial()
		planeMaterial.diffuse.contents = UIColor.yellow.withAlphaComponent(0.3)
		plane.materials = [planeMaterial]
		
		let planeNode = SCNNode(geometry: plane)
		planeNode.position = SCNVector3(center.x, 0, center.z)
		planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
		
		return planeNode
	}
	
	func updatePlaneNode(_ node: SCNNode, center: vector_float3, extent: vector_float3) {
		let geometry = node.geometry as? SCNPlane
		geometry?.width = CGFloat(extent.x)
		geometry?.height = CGFloat(extent.z)
		
		node.position = SCNVector3Make(center.x, 0, center.z)
	}
	
	func makePortal() -> SCNNode {
		
	}
	
	func removeDebugPlanes() {
		for debugPlane in debugPlanes {
			debugPlane.removeFromParentNode()
		}
		
		debugPlanes = []
	}
}

extension ViewController: ARSCNViewDelegate {

	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		if let planeAnchor = anchor as? ARPlaneAnchor, !isPortalPlaced {
			let debugPlane = createPlaneNode(center: planeAnchor.center, extent: planeAnchor.extent)
			node.addChildNode(debugPlane)
			debugPlanes.append(debugPlane)
		} else if !isPortalPlaced {
			portalNode = makePortal()
			
			if let portalNode = portalNode {
				node.addChildNode(portalNode)
				isPortalPlaced = true
				sceneView.debugOptions = []
			}
		}
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		if let planeAnchor = anchor as? ARPlaneAnchor, !isPortalPlaced, !node.childNodes.isEmpty {
			updatePlaneNode(node.childNodes[0], center: planeAnchor.center, extent: planeAnchor.extent)
		}
	}
	
	func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
		DispatchQueue.main.async {
			if let _ = self.sceneView.hitTest(self.view.center, types: .existingPlaneUsingExtent).first {
				self.crosshairView.backgroundColor = .green
			} else {
				self.crosshairView.backgroundColor = .red
			}
		}
	}
}
