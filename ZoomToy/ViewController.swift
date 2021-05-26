//
//  ViewController.swift
//  ZoomToy
//
//  Created by Srivalli on 13/05/21.
//

import UIKit
import MobileRTC

class ViewController: UIViewController {
        
    let meetingNo = "Your Meeting Number"
    let kSDKUserName = ""
    //weak var delegate?: SocketPositionManagerDelegate
    
    var socket: SocketTutorialManager!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        MobileRTC.shared().setMobileRTCRootController(self.navigationController)
        if(self.meetingNo == "") {
            // If the meeting number is empty, return error.
            print("Please enter a meeting number")
            return
        } else {
            // If the meeting number is not empty.
            let getservice = MobileRTC.shared().getMeetingService()
            if let service = getservice {
                service.delegate = self
                let paramDict =      [kMeetingParam_Username:kSDKUserName,kMeetingParam_MeetingNumber:meetingNo, kMeetingParam_MeetingPassword:"",kMeetingParam_WebinarToken:"Your Webinar Token"]
                let response = service.joinMeeting(with: paramDict)
                print("onJoinMeeting, response: \(response)")
            }
        }
    }
    
    func connectToSocket() {
        self.socket = SocketTutorialManager(self)
        let element = UIView(frame: CGRect(x:0, y:0, width: 10, height: 10))
        element.backgroundColor = UIColor.red
        element.center = CGPoint(x: 170, y: 770)
        self.view.addSubview(element)
    }
    
    @IBAction func ConnecttoServerButtonPressed(_ sender: Any) {
        //Socket connect
        self.connectToSocket()
        
        // Zoom connect
        let meetingNum = "9967655297272"
        joinMeeting(meetingNumber: meetingNum)
    }
}

extension ViewController: SocketPositionManagerDelegate {
    
    func didConnect() {
        print("Connect")
    }
    
    func didReceive(position: SocketPosition) {
        let element = UIView(frame: CGRect(x:0, y:0, width: 50, height: 50))
        element.backgroundColor = UIColor.red
        element.center = CGPoint(x: position.x, y: position.y)
        self.view.addSubview(element)
    }
    
}

extension ViewController: MobileRTCMeetingServiceDelegate {
    
    func onMeetingStateChange(_ state: MobileRTCMeetingState) {
       print("\(state)")
    }
    
}


func joinMeeting(meetingNumber: String) {
        // Obtain the MobileRTCMeetingService from the Zoom SDK, this service can start meetings, join meetings, leave meetings, etc.
        if let meetingService = MobileRTC.shared().getMeetingService() {


            // Create a MobileRTCMeetingJoinParam to provide the MobileRTCMeetingService with the necessary info to join a meeting.
            // In this case, we will only need to provide a meeting number and password.
            let joinMeetingParameters = MobileRTCMeetingJoinParam()
            joinMeetingParameters.meetingNumber = meetingNumber
            joinMeetingParameters.password = ""

            // Call the joinMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
            // If the meeting number and meeting password are valid, the user will be put into the meeting. A waiting room UI will be presented or the meeting UI will be presented.
            meetingService.joinMeeting(with: joinMeetingParameters)
        }
}
