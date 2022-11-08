//
//  CoinData.swift
//  Bitcoin Price Check
//
//  Created by Vinicius Pinheiro de Oliveira on 08/11/22.
//

import Foundation

//Struct conforme os decodable protocolos para usar em nosso JSON

struct CoinData: Decodable {
    
    //apenas uma propriedade que nos interessa no JSON data. O ultimo preço da bitcoin
    //por ser decimal, vamos adicionar como data type
    let rate: Double
}
