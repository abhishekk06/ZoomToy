//
//  AppDelegate.swift
//  ZoomToy
//
//  Created by Srivalli on 13/05/21.
//


import UIKit
import MobileRTC

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Obtain your SDK Key and SDK Secret and paste it here.
    // Your SDK Secret should never be publicly accessible, only use the sdk key and secret for testing this demo app.
    // For a production level application, you must generate a JWT using SDK Key and Secret securely instead of using the SDK Key and SDK Secret directly on the client.
    let sdkKey = "jvJggFAi3scx9LGmmFvCXPkNCnPEmNHXKO9w"
    let sdkSecret = "k1akN1NzJ1g5PD8NWbLn2lUxtcwDbzoQQFxG"
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupSDK(sdkKey: sdkKey, sdkSecret: sdkSecret)

        return true
    }

    /// setupSDK Creates, Initializes, and Authorizes an instance of the Zoom SDK. This must be called before calling any other SDK functions.
 
    /// - Parameters:
    ///   - sdkKey: A valid SDK Client Key provided by the Zoom Marketplace.
    ///   - sdkSecret: A valid SDK Client Secret provided by the Zoom Marketplace.
    func setupSDK(sdkKey: String, sdkSecret: String) {
        // Create a MobileRTCSDKInitContext. This class contains attributes for determining how the SDK will be used. You must supply the context with a domain.
        let context = MobileRTCSDKInitContext()
        // The domain we will use is zoom.us
        context.domain = "zoom.us"
        // Turns on SDK logging. This is optional.
        context.enableLog = true
        context.appGroupId = "group.kumarab3.ZoomToy"

        // Call initialize(_ context: MobileRTCSDKInitContext) to create an instance of the Zoom SDK. Without initialization, the SDK will not be operational. This call will return true if the SDK was initialized successfully.
        let sdkInitializedSuccessfully = MobileRTC.shared().initialize(context)

        // Check if initialization was successful. Obtain a MobileRTCAuthService, this is for supplying credentials to the SDK for authorization.
        if sdkInitializedSuccessfully == true, let authorizationService = MobileRTC.shared().getAuthService() {

 // Supply the SDK with SDK Key and SDK Secret.
// To use a JWT instead, replace these lines with authorizationService.jwtToken = yourJWTToken.
            authorizationService.clientKey = sdkKey
            authorizationService.clientSecret = sdkSecret

            // Assign AppDelegate to be a MobileRTCAuthDelegate to listen for authorization callbacks.
            authorizationService.delegate = self

            // Call sdkAuth to perform authorization.
            authorizationService.sdkAuth()
        }
    }
}

// MARK: - MobileRTCAuthDelegate
// Conform AppDelegate to MobileRTCAuthDelegate.
// MobileRTCAuthDelegate listens to authorization events like SDK authorization, user login, etc.
extension AppDelegate: MobileRTCAuthDelegate {

    // Result of calling sdkAuth(). MobileRTCAuthError_Success represents a successful authorization.
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        switch returnValue {
        case .success:
            print("SDK successfully initialized.")
        case .keyOrSecretEmpty:
            assertionFailure("SDK Key/Secret was not provided. Replace sdkKey and sdkSecret at the top of this file with your SDK Key/Secret.")
        case .keyOrSecretWrong, .unknown:
            assertionFailure("SDK Key/Secret is not valid.")
        default:
            assertionFailure("SDK Authorization failed with MobileRTCAuthError: \(returnValue).")
        }
    }

  }
