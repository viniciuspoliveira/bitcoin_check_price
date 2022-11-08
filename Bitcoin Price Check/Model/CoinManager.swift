//
//  CoinManager.swift
//  Bitcoin Price Check
//
//  Created by Vinicius Pinheiro de Oliveira on 08/11/22.
//

import Foundation


//por convencao, switf procolos sao escritos no arquivo que a classe/struct que vao chamar os metods delegados
protocol CoinManagerDelegate {
    
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
    
}

struct CoinManager {
    
   
    var delegate: CoinManagerDelegate?
   
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "5D41CC96-7E80-4E31-AC42-4529A0659858"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        //String concatenation pra adicionar a moeda selecionada no final da baseURL juntamente com API
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //usar optional binding para unwrap a URL criada pelo urlString
        if let url = URL(string: urlString) {
            
            //criar nova URLsession com cinfiguraçao default
            let session = URLSession(configuration: .default)
            
            //criar nova data task da URL Session
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        
                        //optional: arredondar para 2 casas decimais
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        
                        //chama o delegate method in the delegate (viewController) e passa os dados necessários.
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
                
                //formatar data que recebemos como String para usar o print
//                let dataAsString = String(data: data!, encoding: .utf8)
//                print(dataAsString)
                
            }
            //iniciar uma task para fetch data dos servidores bitcoin
            task.resume()
            
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        //criar um JSONDecoder
        
        let decoder = JSONDecoder()
        do {
            
            //tentar decodificar os dados usando coinData struct
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            //pegar ultima propriedade do decoded data
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            
        } catch {
            
            //pegar print de qualquer erro
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
