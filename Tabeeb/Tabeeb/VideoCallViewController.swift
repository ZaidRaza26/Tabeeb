//
//  VideoCallViewController.swift
//  Tabeeb
//
//  Created by Tamim Dari on 2/17/20.
//  Copyright © 2020 SZABIST. All rights reserved.
//

import UIKit
import OpenTok

// Replace with your OpenTok API key
var kApiKey = "46514172"
// Replace with your generated session ID
var kSessionId = "2_MX40NjUxNDE3Mn5-MTU4MTg4NTU2Mzk1MH5XZ1oxSWVwRml3Mk1LZmJlK254cEt4S3h-fg"
// Replace with your generated token
var kToken = "T1==cGFydG5lcl9pZD00NjUxNDE3MiZzaWc9MWY2ZjQ3YTc5N2E3ZDZjZjY3ODA3ZDExZDNhYjZmNmUzOGU1ODk1ZDpzZXNzaW9uX2lkPTJfTVg0ME5qVXhOREUzTW41LU1UVTRNVGc0TlRVMk16azFNSDVYWjFveFNXVndSbWwzTWsxTFptSmxLMjU0Y0V0NFMzaC1mZyZjcmVhdGVfdGltZT0xNTgxODg1NjAzJm5vbmNlPTAuMjMyODYxMDgyMDM4MDY0Nzcmcm9sZT1tb2RlcmF0b3ImZXhwaXJlX3RpbWU9MTU4NDQ3NDAwMiZpbml0aWFsX2xheW91dF9jbGFzc19saXN0PQ=="


class VideoCallViewController: UIViewController {

    var session: OTSession?
    var publisher: OTPublisher?
    var subscriber: OTSubscriber?



    override func viewDidLoad() {
        super.viewDidLoad()

           let configuration = URLSessionConfiguration.default
           let session = URLSession(configuration: configuration)
           let url = URL(string: "https://tabeeb26.herokuapp.com/session")
           let dataTask = session.dataTask(with: url!) {
               (data: Data?, response: URLResponse?, error: Error?) in

               guard error == nil, let _data = data else {
                   print(error!)
                   return
               }

               let dict = try! JSONSerialization.jsonObject(with: _data, options: .allowFragments) as? [AnyHashable: Any]
               kApiKey = dict?["apiKey"] as? String ?? ""
               kSessionId = dict?["sessionId"] as? String ?? ""
               kToken = dict?["token"] as? String ?? ""
               self.connectToAnOpenTokSession()
           }
           dataTask.resume()
           session.finishTasksAndInvalidate()

    }
    
    
  func connectToAnOpenTokSession() {
        session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)
        var error: OTError?
        session?.connect(withToken: kToken, error: &error)
        if error != nil {
            print(error!)
        }
    }

    
}



extension VideoCallViewController: OTSessionDelegate {
   func sessionDidConnect(_ session: OTSession) {
    
    print("The client connected to the OpenTok session.")

       let settings = OTPublisherSettings()
       settings.name = UIDevice.current.name
       guard let publisher = OTPublisher(delegate: self, settings: settings) else {
           return
       }

       var error: OTError?
       session.publish(publisher, error: &error)
       guard error == nil else {
           print(error!)
           return
       }

       guard let publisherView = publisher.view else {
           return
       }
       let screenBounds = UIScreen.main.bounds
       publisherView.frame = CGRect(x: screenBounds.width - 150 - 20, y: screenBounds.height - 150 - 20, width: 150, height: 150)
       view.addSubview(publisherView)
    
    
    }

   func sessionDidDisconnect(_ session: OTSession) {
       print("The client disconnected from the OpenTok session.")
   }

   func session(_ session: OTSession, didFailWithError error: OTError) {
       print("The client failed to connect to the OpenTok session: \(error).")
   }

   func session(_ session: OTSession, streamCreated stream: OTStream) {
      subscriber = OTSubscriber(stream: stream, delegate: self)
          guard let subscriber = subscriber else {
              return
          }

          var error: OTError?
          session.subscribe(subscriber, error: &error)
          guard error == nil else {
              print(error!)
              return
          }

          guard let subscriberView = subscriber.view else {
              return
          }
          subscriberView.frame = UIScreen.main.bounds
          view.insertSubview(subscriberView, at: 0)
    
    }

   func session(_ session: OTSession, streamDestroyed stream: OTStream) {
       print("A stream was destroyed in the session.")
   }
}

// MARK: - OTPublisherDelegate callbacks
extension VideoCallViewController: OTPublisherDelegate {
   func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
       print("The publisher failed: \(error)")
   }
}

// MARK: - OTSubscriberDelegate callbacks
extension VideoCallViewController: OTSubscriberDelegate {
   public func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
       print("The subscriber did connect to the stream.")
   }

   public func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
       print("The subscriber failed to connect to the stream.")
   }
}
