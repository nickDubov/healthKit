//
//  ViewController.swift
//  healthKitRead
//
//  Created by Nick on 06/04/2020.
//  Copyright © 2020 nick. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //authorization for reading data from HealthKit
        requestPermissions()
        
        
    }
    
    @IBAction func getData(_ sender: UIButton) {
        self.readData()
    }
    
    func requestPermissions(){
        let healthKitTypesToRead : Set<HKSampleType> = [
            HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
            HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
        ]

        let healthKitTypesToWrite: Set<HKSampleType> = [
            HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
            HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
        ]

        if !HKHealthStore.isHealthDataAvailable() {
            print("Error: HealthKit is not available in this Device")
            return
        }

        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead)
        { (success, error) -> Void in
            print("Read Write Authorization succeeded")
        }
        
    }
    
    func readData(){
        //Read Height
        do {
            let heightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
            let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                if let result = results?.first as? HKQuantitySample{
                    print("Height => \(result.quantity)")
                }else{
                    print("OOPS didnt get height \nResults => \(String(describing: results)), error => \(String(describing: error))")
                }
            }
            self.healthKitStore.execute(query)
        } catch{
            print("Height not found")
        }
        //Read Weight
        do {
            let WeightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
            let query = HKSampleQuery(sampleType: WeightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                if let result = results?.first as? HKQuantitySample{
                    print("Height => \(result.quantity)")
                }else{
                    print("OOPS didnt get weight \nResults => \(String(describing: results)), error => \(String(describing: error))")
                }
            }
            self.healthKitStore.execute(query)
        } catch{
            print("Weight not found")
        }
    }
}


