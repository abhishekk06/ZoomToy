//
//  SampleHandler.swift
//  ScreenShare
//
//  Created by Abhishek Kumar on 5/19/21.
//


import ReplayKit

class SampleHandler: RPBroadcastSampleHandler, MobileRTCScreenShareServiceDelegate {

    var screenShareService: MobileRTCScreenShareService?

    override init() {
        super.init()

        screenShareService = MobileRTCScreenShareService()
        screenShareService?.delegate = self
        screenShareService?.appGroup = "group.kumarab3.ZoomToy"
        
    }

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        screenShareService?.broadcastStarted(withSetupInfo: setupInfo)
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
        screenShareService?.broadcastPaused()
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
        screenShareService?.broadcastResumed()
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        screenShareService?.broadcastFinished()
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        screenShareService?.processSampleBuffer(sampleBuffer, with: sampleBufferType)
    }

    func mobileRTCScreenShareServiceFinishBroadcastWithError(_ error: Error!) {
        finishBroadcastWithError(error)
    }
}
