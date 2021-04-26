# CAITestApp

The test application is able to render static mock data but also to connect against a live system. Adjust `./CAITestApp/Connections.plist` to specify system, OAuth authorization details as well as dedicated channel information, then recompile and run the app.

Example for `Connections.plist`

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
	<dict>
		<key>name</key>
		<string>Community (P)</string>
		<key>baseURL</key>
		<string>https://api.cai.tools.sap</string>
		<key>authorizationEndpointURL</key>
		<string>https://sapcai-community.authentication.eu10.hana.ondemand.com/oauth/authorize</string>
		<key>tokenEndpointURL</key>
		<string>https://sapcai-community.authentication.eu10.hana.ondemand.com/oauth/token</string>
		<key>redirectURL</key>
		<string>https://sapcai-community.sapcai.eu10.hana.ondemand.com/login/callback</string>
		<key>clientId</key>
		<string>sb-cai-production!z99999</string>
		<key>clientSecret</key>
		<string>aa9AaaaOQa9aaAaA9aaAa0Aaaaa=</string>
	</dict>
</array>
</plist>
```

Schema for `Connections.plist`

|Key|Data Type|Purpose|Example|
|---|---|---|---|
|name|String|Display Name|Community|
|baseURL|String|Base URL referring to SAP Conversational AI|https://api.cai.tools.sap|
|authorizationEndpointURL|String|OAuth authorization URL|https://sapcai-community.authentication.eu10.hana.ondemand.com/oauth/authorize|
|tokenEndpointURL|String|OAuth token endpoint URL|https://sapcai-community.authentication.eu10.hana.ondemand.com/oauth/token|
|redirectURL|String|OAuth redirect URL|https://sapcai-community.sapcai.eu10.hana.ondemand.com/login/callback|
|clientId|String|OAuth client id|sb-cai-production!z99999|
|clientSecret|String|OAuth client secret (mandatory for CAI, optional for Mobile Services)|aa9AaaaOQa9aaAaA9aaAa0Aaaaa=|
|developerToken|String|Optional|9aa9aa9a99aa9a9a9a9a999a9a99a99a|
|channelId|String|Optional; to be supplied for direct channel access|5797193f-dd10-481f-a044-6a389151f98e|
|channelToken|String|Optional; to be supplied for direct channel access|8aa8aa8a88aa8a8a8a8a888a8a88a88a|
|channelSlug|String|Optional; to be supplied for direct channel access|my-mobile-bot-slug-name|
|conversationId|String|Optional; to be supplied to render an existing conversation|2b2eabf3-d995-45a7-b8c5-1d36d626fcfe|
