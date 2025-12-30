//
//  Cacheable.swift
//  IPAddress2Geolocation
//
//  Created by Mac on 14/12/25.
//

protocol FileCacheable {
    associatedtype CacheType: Codable
    
    var cache: Cache<String, CacheType> {get set}
    var cacheName: String {get}
    
    func saveCacheFile()
    mutating func loadCacheFile()
    func deleteCacheFile()
}

extension FileCacheable {
    var cacheName: String {
        String(describing: self)
    }
}

extension FileCacheable {
    func saveCacheFile() {
        cache.saveCache(with: cacheName)
    }
    mutating func loadCacheFile() {
        do {
            cache = try Cache.loadCache(with: cacheName)
        } catch {
            print(String(describing: error))
        }
    }
    func deleteCacheFile() {
        do {
            cache.removeCache()
            try cache.deleteCache(with: cacheName)
        } catch {
            print(String(describing: error))
        }
    }
}
