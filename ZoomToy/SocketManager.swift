//
//  SocketManager.swift
//  ZoomToy
//
//  Created by Keshav Bansal on 26/05/21.
//

import Foundation
import SocketIO

protocol SocketPositionManagerDelegate: AnyObject {
    func didConnect()
    func didReceive(position: SocketPosition)
}

class SocketTutorialManager {

    // MARK: - Delegate
    weak var delegate: SocketPositionManagerDelegate?

    // MARK: - Properties
    let manager = SocketManager(socketURL: URL(string: "https://socket-io-whiteboard.now.sh")!, config: [.log(false), .compress])
    var socket: SocketIOClient? = nil

    // MARK: - Life Cycle
    init(_ delegate: SocketPositionManagerDelegate) {
        self.delegate = delegate
        self.setupSocket()
        self.setupSocketEvents()
        self.socket?.connect()
    }

    func stop() {
        socket?.removeAllHandlers()
    }

    // MARK: - Socket Setups
    func setupSocket() {
        self.socket = self.manager.defaultSocket
    }

    
    func setupSocketEvents() {
        
        self.socket?.on(clientEvent: .connect) {data, ack in
            self.delegate?.didConnect()
        }
        
        self.socket?.on(clientEvent: .error, callback: { data, ack in
            print(data)
        })
        
        self.socket?.on(clientEvent: .statusChange, callback: { data, ack in
            print(data)
        })
        
        socket?.on("drawing") { (data, ack) in
            guard let dataInfo = data.first else { return }
            if let response: SocketPosition = try? SocketParser.convert(data: dataInfo) {
                let position = SocketPosition(x: response.x, y: response.y)
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
