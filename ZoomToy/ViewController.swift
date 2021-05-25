//
//  ViewController.swift
//  ZoomToy
//
//  Created by Srivalli on 13/05/21.
//

import UIKit
import MobileRTC
import SocketIO

class SocketParser {

    static func convert<T: Decodable>(data: Any) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: jsonData)
    }

    static func convert<T: Decodable>(datas: [Any]) throws -> [T] {
        return try datas.map { (dict) -> T in
            let jsonData = try JSONSerialization.data(withJSONObject: dict)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: jsonData)
        }
    }

}

struct SocketPosition: Codable {
    var x: Double
    var y: Double
}

protocol SocketPositionManagerDelegate: class {
    func didConnect()
    func didReceive(position: SocketPosition)
}

class SocketTutorialManager{

    // MARK: - Delegate
    weak var delegate: SocketPositionManagerDelegate?

    // MARK: - Properties
    let manager = SocketManager(socketURL: URL(string: "https://socket-io-whiteboard.now.sh")!, config: [.log(true), .compress])
    var socket: SocketIOClient? = nil

    // MARK: - Life Cycle
    init(_ delegate: SocketPositionManagerDelegate) {
        self.delegate = delegate
        setupSocket()
        setupSocketEvents()
        socket?.connect()
    }

    func stop() {
        socket?.removeAllHandlers()
    }

    // MARK: - Socket Setups
    func setupSocket() {
        self.socket = manager.defaultSocket
    }

    
    func setupSocketEvents() {

           socket?.on(clientEvent: .connect) {data, ack in
               self.delegate?.didConnect()
           }

           socket?.on("drawing") { (data, ack) in
               guard let dataInfo = data.first else { return }
               if let response: SocketPosition = try? SocketParser.convert(data: dataInfo) {
                let position = SocketPosition.init(x: response.x, y: response.y)
                self.delegate?.didReceive(position: position)
               }
           }

       }

    // MARK: - Socket Emits
    func socketChanged(position: SocketPosition) {
        let info: [String : Any] = [
            "x": Double(position.x),
            "y": Double(position.y)
        ]
        socket?.emit("drawing", info)
    }
}

class ViewController: UIViewController {
        
    let meetingNo = "Your Meeting Number"
    let kSDKUserName = ""
    //weak var delegate: SocketPositionManagerDelegate
    
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
        
        //var socket = SocketTutorialManager(delegate)
        //----------Sample example-------------------//
        /*let manager = SocketManager(socketURL: URL(string: "https://socket-io-whiteboard.now.sh")!, config: [.log(true), .compress])
        let socket = manager.defaultSocket

        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("drawing") { (data, ack) in
            guard let dataInfo = data.first else { return }
            if let response: SocketPosition = try? SocketParser.convert(data: dataInfo) {
             let position = SocketPosition.init(x: response.x, y: response.y)
             didReceive(point: position)
            }
        }
        socket.connect()*/
        //----------Sample example-------------------//
    }
    
    @IBAction func ConnecttoServerButtonPressed(_ sender: Any) {
        let meetingNum = "99676552972"
        joinMeeting(meetingNumber: meetingNum)
    }
}

extension ViewController: MobileRTCMeetingServiceDelegate{
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

func didReceive(point: SocketPosition) {
  let element = UIView(frame: CGRect(x:0, y:0, width: 100, height: 100))
  element.backgroundColor = UIColor.red
  element.center = CGPoint(x: point.x, y: point.y)
}
