//
//  Result.swift
//  Tabeeb
//
//  Created by macbook on 20/09/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//


enum Result<T>{
    case success(T)
    case failure(String)
}
