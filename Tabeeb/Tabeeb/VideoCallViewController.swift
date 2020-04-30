//
//  VideoCallViewController.swift
//  Tabeeb
//
//  Created by Tamim Dari on 2/17/20.
//  Copyright © 2020 SZABIST. All rights reserved.
//

import UIKit
import OpenTok
import Firebase

// Replace with your OpenTok API key


class VideoCallViewController: UIViewController {

    var session: OTSession?
    var publisher: OTPublisher?
    var subscriber: OTSubscriber?
    var videocall: VideoCall!

    


    override func viewDidLoad() {
        super.viewDidLoad()
        connectToAnOpenTokSession(ksessionId:videocall.sessionId,kToken: videocall.token,kApiKey: videocall.apiKey)
        
        

    }
    
    
    func connectToAnOpenTokSession(ksessionId:String,kToken:String,kApiKey:String) {
        session = OTSession(apiKey: kApiKey, sessionId: ksessionId, delegate: self)
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
    
//    func GetSessionIdFromFirestoreOnReceiving(completion: @escaping (String)->Void){
//        Firestore.firestore().collection("videocall").document(CurrentUser.shared.id)
//           .addSnapshotListener { documentSnapshot, error in
//             guard let document = documentSnapshot else {
//               print("Error fetching document: \(error!)")
//               return
//             }
//             guard let data = document.data() else {
//               print("Document data was empty.")
//               return
//             }
//             print("Current data: \(data)")
//            if let sessionId = data["sessionId"] as? String{
//                completion(sessionId)
//            }
//        }
//    }
    
    
    
 
    
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
