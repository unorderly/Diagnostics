//
//  Device.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

enum Device {
    static var systemName: String {
        #if os(macOS) || targetEnvironment(macCatalyst)
        return ProcessInfo.systemName
        #else
        return UIDevice.current.systemName
        #endif
    }

    static var systemVersion: String {
        #if os(macOS) || targetEnvironment(macCatalyst)
        return ProcessInfo().operatingSystemVersionString
        #else
        return UIDevice.current.systemVersion
        #endif
    }

    static var freeDiskSpace: ByteCountFormatter.Units.GigaBytes {
        ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }

    static var totalDiskSpace: ByteCountFormatter.Units.GigaBytes {
        ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }

    static var totalDiskSpaceInBytes: ByteCountFormatter.Units.Bytes {
        guard let space = try? URL(fileURLWithPath: NSHomeDirectory() as String)
            .resourceValues(forKeys: [URLResourceKey.volumeTotalCapacityKey])
            .volumeTotalCapacity else {
            return 0
        }
        return Int64(space)
    }

    static var freeDiskSpaceInBytes: ByteCountFormatter.Units.Bytes {
        guard let space = try? URL(fileURLWithPath: NSHomeDirectory() as String)
            .resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForOpportunisticUsageKey])
            .volumeAvailableCapacityForOpportunisticUsage else {
            return 0
        }
        return space
    }
}

#if os(macOS) || targetEnvironment(macCatalyst)
extension ProcessInfo {
    static var model: String {
        if #available(macCatalyst 15.0, *) {
            let service = IOServiceGetMatchingService(kIOMainPortDefault,
                                                      IOServiceMatching("IOPlatformExpertDevice"))
            
            var modelIdentifier: String?
            if let modelData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data {
                modelIdentifier = String(data: modelData, encoding: .utf8)?.trimmingCharacters(in: .controlCharacters)
            }
            
            IOObjectRelease(service)
            return modelIdentifier ?? "macOS"
        } else {
            return "macOS"
        }
    }
    
    static var systemName: String {
        var sysinfo = utsname()
        let result = uname(&sysinfo)
        guard result == EXIT_SUCCESS else { return "macOS (unknown)" }
        let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        guard let identifier = String(bytes: data, encoding: .ascii) else { return "macOS (unknown)" }
        let arch = identifier.trimmingCharacters(in: .controlCharacters)
        switch arch {
        case "arm64": return "macOS (Apple Silicon)"
        case "x86_64": return "macOS (Intel)"
        default: return "macOS (\(arch))"
        }
    }
}
#endif
