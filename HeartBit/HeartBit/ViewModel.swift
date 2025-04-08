
//
//  ViewModel.swift
//  trabaio
//
//  Created by Turma01-15 on 03/04/25.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var bpms: [bpm] = []
    
    func fetch(){
        guard let url = URL(string: "http://192.168.128.8:1880/getbatimentosteste") else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
            
            guard let data = data, error == nil else{
                return
            }
            
            do{
                
                let parsed = try JSONDecoder().decode([bpm].self, from: data)
                
                DispatchQueue.main.async {
                    
                    self?.bpms = parsed
                    self?.bpms.sort(by: {$0.data! < $1.data!})
                }
            } catch{
                print(error)
            }
        }
        task.resume()
    }
}
