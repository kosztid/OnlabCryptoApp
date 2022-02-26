//
//  ImageDownloader.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import Foundation
import Combine
import SwiftUI

class ImageDownloader{
    var imagesub: AnyCancellable?
    var image: UIImage = UIImage()
    
    init(){
        loadimages()
    }
    
    func loadimages(){
        guard let url = URL(string:"https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579")
        else {
            return
        }
        let _ = print("loaded image")
        imagesub = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .tryMap({(date) -> UIImage? in
                return UIImage(data: date)
            })
            .sink{(completion) in
                switch completion {
                case .finished:
                    let _ = print("successssss")
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage ?? UIImage()
                self?.imagesub?.cancel()
            }
        
    }
}
