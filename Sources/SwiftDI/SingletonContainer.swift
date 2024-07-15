//
//  File.swift
//  
//
//  Created by brainx on 15/07/2024.
//

import Foundation

class SingletonContainer<T>: Storable {

    var identifier = UUID()
    var instance: T

    init(instance: T) {
        self.instance = instance
    }

}
