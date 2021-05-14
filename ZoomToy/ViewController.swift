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
override func viewDidLoad() {
super.viewDidLoad()
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
}
extension ViewController: MobileRTCMeetingServiceDelegate{
    func onMeetingStateChange(_ state: MobileRTCMeetingState) {
       print("\(state)")
    }
}
/*
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
*/
