//
//  AppDelegate.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 02/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import CoreData
import FeedKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    @objc static var darkMode = true
    public static var news : RSSFeed?
    public static var stockData = [String:StockDataSource]()
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        getDarkUser()
        
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            AppDelegate.news = stockNews(forStockName: "AAPL")?.parse().rssFeed
//        }
        
        
        
        if let stocks = allStocksUnderWatch(){
            for stock in stocks{
                var new = StockDataSource()
                new.name = stock.name!
                AppDelegate.stockData.updateValue(new, forKey: stock.name!)
            }
        }
        
        StockDetails.getStockPriceUnderWatch()
        
        // Update Stocks Quotes Perodically
        DispatchQueue.global(qos: .userInitiated).async {
            while true{
                sleep(60)
                StockDetails.getStockPriceUnderWatch()
                executeOrders()
            }
        }
        
    
        
        

        
        
        print("News Fetched")
        if(!UserDefaults.standard.bool(forKey: "HasLaunchedOnce")){
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
            createUser()
            createSamplePortfolio()
        }
        
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    @objc lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "VirtualMarket")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @objc func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    

}

