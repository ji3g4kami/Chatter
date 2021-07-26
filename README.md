# Chatter
This is an updated code from [Beginning Realm on iOS](https://www.raywenderlich.com/4146-beginning-realm-on-ios). The course had been using Swift 3 and APIs have changed.    

## Fixes for Swift 5
- Adorable Avartar is not longer supporting. Swap the service to:
```swift
func imageUrlForName(_ name: String) -> URL {
    return URL(string: "https://api.hello-avatar.com/adorables/150/" + name.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)! + ".png")!
}
```
- Failed to install Realm CocoaPods
1. Remove version constraints in Podfile
2. `$rm -rf ~/Library/Caches/CocoaPods/Pods/Release`
3. `$rm -rf ~/Library/Caches/CocoaPods/Pods/Specs`
4. `$pod install`

- Realm model properties must have the `@objc dynamic var` attribute to become accessors for the underlying database data. Note that if the class is declared as `@objcMembers` (Swift 4 or later), the individual properties can just be declared as `dynamic var`.

- [Realm Browser is deprecated](https://github.com/realm/realm-cocoa/issues/4795). Use [Realm Studio](https://docs.mongodb.com/realm/studio/) instead.

- Realm's `addNotificationBlock` has been renamed to `observe`.