import Foundation
import Security

public struct KeyChainAccessGroupInfo {
    public var prefix: String
    public var keyChainGroup: String
    public var rawValue: String
}

open class KeyChainAccessGroupHelper {
    
    public class func getAccessGroupInfo() -> KeyChainAccessGroupInfo? {
        let query: [String:Any] = [
            kSecClass as String : kSecClassGenericPassword,
             kSecAttrAccount as String : "flutter_secure_storage_service",
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecReturnAttributes as String : kCFBooleanTrue!
        ]
        
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        
        if status == errSecItemNotFound {
            let createStatus = SecItemAdd(query as CFDictionary, nil)
            guard createStatus == errSecSuccess else { return nil }
            status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        }
        
        guard status == errSecSuccess else { return nil }
        
        let accessGroup = ((dataTypeRef as! [AnyHashable: Any])[(kSecAttrAccessGroup as String)] as! String)
        
        if accessGroup.components(separatedBy: ".").count > 0 {
            let components = accessGroup.components(separatedBy: ".")
            let prefix = components.first!
            let elements = components.filter() { $0 != prefix }
            let keyChainGroup = elements.joined(separator: ".")
            
            return KeyChainAccessGroupInfo(prefix: prefix, keyChainGroup: keyChainGroup, rawValue: accessGroup)
        }
        
        return nil
    }
}
