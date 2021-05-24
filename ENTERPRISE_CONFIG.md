# Enterprise Configuration

This guide shall help enterprise customers to understand the configuration needed to use `SAPCAI` Swift package to connect indirectly with SAP Conversational AI through SAP Mobile Services.

## Prerequisites

You are using
* SAP Conversational AI *Enterprise Edition*
* SAP Mobile Services

Both services
* run on the same Business Techology Platform (BTP) subaccount
* use the trust provider of the subaccount

## Configuration Steps

### SAP Conversational AI

If not already done create OAuth client for Designtime API in your bot
<kbd>Settings</kbd> > <kbd> Tokens</kbd>

### SAP Mobile Services

Create a destination with the following information:

  * URL: `URL to your CAI Enterprise Edition with suffix "/public/api"`
  * SSO Mechanism: OAuth2 User Token Exchange
  * Forward User Token to AppRouter: true
  * Token Service URL: `Auth URL for CAI Designtime API for your bot`
  * Token Service URL Type: Dedicated
  * Client ID: `Client ID for CAI Designtime API for your bot`
  * Client Secret: `Client Secret of CAI Designtime API for your bot`

If you are planning to retrieve a list of channels (through `CAIChannelService` in your iOS app) then create the following custom header:

* Header Name: X-Token
* Header Value: <your CAI developer token>
* Override Client: false

### iOS App

To instantiate `CAIServiceConfig` reuse the `SAPURLSession` instance used for authentication against mobile services.

```swift
let serviceConfig = CAIServiceConfig(urlSession: session, host: URL(string:"Destination URL pointing to the destination created in Mobile Services")!)
```

