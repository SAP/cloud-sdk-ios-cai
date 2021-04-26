build:
	xcodebuild -scheme SAPCAI -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 11' clean build
test:
	xcodebuild -scheme SAPCAI-Package -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 11' clean test
snapshottest:
	xcodebuild -project ./CAITestApp/CAITestApp.xcodeproj -scheme CAITestAppTests -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 11' test
uitest:
	xcodebuild -project ./CAITestApp/CAITestApp.xcodeproj -scheme CAITestAppUITests -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 11' test
jazzy:
	sourcekitten doc --module-name SAPCAI -- -scheme SAPCAI -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 11' clean build > sapcai.json
	jazzy --sourcekitten-sourcefile sapcai.json --module "SAPCAI" --clean
	rm sapcai.json
