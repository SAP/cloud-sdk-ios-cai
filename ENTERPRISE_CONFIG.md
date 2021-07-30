# Enterprise Configuration

This guide shall help enterprise customers to understand the configuration needed to use `SAPCAI` Swift package to connect indirectly with SAP Conversational AI through SAP Mobile Services.

## Prerequisites

You are using SAP Conversational AI *Enterprise Edition* and SAP Mobile Services.
  
## Configuration Steps - SAP Conversational AI

If not already done create OAuth client for Designtime API in your bot
<kbd>Settings</kbd> > <kbd> Tokens</kbd>

## Configuration Steps - SAP Mobile Services

Destination and SSO Mechanism depend on the deployment scenario:
* Use `OAuth2 User Token Exchange` when both services run on the same Business Technology Platform (BTP) subaccount
* Use `OAuth2 SAML Bearer Assertion` when services run on different subaccounts or regions
  * Prerequisite: [trust established between subaccounts](https://help.sap.com/viewer/cca91383641e40ffbe03bdc78f00f681/Cloud/en-US/8ebf60c82a8e4cfc904f441c0c0acd6b.html#loio8ebf60c82a8e4cfc904f441c0c0acd6b__establish)
### OAuth2 User Token Exchange

Create a destination with the following information:

  * URL: URL to your CAI Enterprise Edition with suffix "/public/api"
  * SSO Mechanism: OAuth2 User Token Exchange
  * Propagate User Name: true
  * Token Service URL: Auth URL for CAI Designtime API for your bot
  * Token Service URL Type: Dedicated
  * Client ID: Client ID for CAI Designtime API for your bot
  * Client Secret: Client Secret of CAI Designtime API for your bot

### OAuth2 SAML Beaer Assertion

Create a destination with the following information:

  * URL: URL to your CAI Enterprise Edition with suffix "/public/api"
  * SSO Mechanism: OAuth2 SAML Bearer Assertion
  * Propagate User Name: true
  * Audience: see [Create an OAuthSAMLBearerAssertion Destination for Application 1](https://help.sap.com/viewer/cca91383641e40ffbe03bdc78f00f681/Cloud/en-US/8ebf60c82a8e4cfc904f441c0c0acd6b.html#loio8ebf60c82a8e4cfc904f441c0c0acd6b__create)
  * Token Service URL: see [Create an OAuthSAMLBearerAssertion Destination for Application 1](https://help.sap.com/viewer/cca91383641e40ffbe03bdc78f00f681/Cloud/en-US/8ebf60c82a8e4cfc904f441c0c0acd6b.html#loio8ebf60c82a8e4cfc904f441c0c0acd6b__create)
  * Token Service URL Type: Dedicated
  * Client Key: Client ID for CAI Designtime API for your bot
  * Client Secret: Client Secret of CAI Designtime API for your bot
  * SAML Assertion Issuer: Name a issuer
  * Signing Key: You can click the "Generate Key" to generate one.
  * Name ID Format: urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified
  * Authentication Context: urn:oasis:names:tc:SAML:2.0:ac:classes:PreviousSession

See [User Propagation between Cloud Foundry Applications](https://help.sap.com/viewer/cca91383641e40ffbe03bdc78f00f681/Cloud/en-US/8ebf60c82a8e4cfc904f441c0c0acd6b.html) for more information.

### iOS App

To instantiate `CAIServiceConfig`, reuse the `SAPURLSession` instance used for authentication against mobile services.

```swift
let serviceConfig = CAIServiceConfig(urlSession: session, host: URL(string:"Destination URL pointing to the destination created in Mobile Services")!)
```

