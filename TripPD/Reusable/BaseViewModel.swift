//
//  BaseViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/26/24.
//

import Foundation
import Combine

protocol BaseViewModel: AnyObject, ObservableObject {
    associatedtype Input
    associatedtype Output
    associatedtype Action
    
    var cancellable: Set<AnyCancellable> { get set }
    
    var input: Input { get set }
    var output: Output { get set }
    
    func transform()
    
    func action(action: Action)
}
