//
//  HomeScreenViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 02/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import CoreData
import iCarousel


class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, iCarouselDelegate, iCarouselDataSource {

    
    
    // Labels
    @IBOutlet weak var netWorthLabel: UILabel!
    @IBOutlet weak var netWorth: UILabel!
    @IBOutlet weak var netWorthCent: UILabel!
    @IBOutlet weak var change: UILabel!
    //Empty indicator lables
    @IBOutlet weak var pendingOrderEmpty: UILabel!
    @IBOutlet weak var newsEmpty: UILabel!
    @IBOutlet weak var portfolioEmpty: UILabel!
    
    
    @IBOutlet weak var orderScrollView: UIScrollView!
    @IBOutlet weak var newsScrollView: UIScrollView!
    @IBOutlet weak var stockTableView: UITableView!
    
    
    @IBOutlet weak var segmentedControl2: SegmentedControl!
    @IBOutlet weak var carouselView: iCarousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.stockTableView.rowHeight = 70.0
        self.stockTableView.delegate = self
        self.stockTableView.dataSource = self
        
        self.carouselView.delegate = self
        self.carouselView.dataSource = self
        self.carouselView.type = .timeMachine
        
        

        
        
    }
    
    func updateStocks(delay time: UInt32){
        DispatchQueue.global(qos: .userInitiated).async {
            while true{
                sleep(time)
                self.stockTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLabelColor()
        setEmptyIndicator()
        
        self.view.backgroundColor = CurrentSettings.getTheme()["light"]
        
        let netWorth = String(describing: getPortfolioValue())
        let sPrice = netWorth.components(separatedBy: ".")
        
        self.netWorth.text = sPrice.first
        self.netWorthCent.text = "." + sPrice[1]
        
        // WARNING to change to show absolute price as well as percentage
        self.change.text = String(describing: getROI())
        
        updateStocks(delay: 60)
     }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if CurrentSettings.getStatusBar() == "light"{
            return .lightContent
            
        } else {
            return .default
            
        }
    }
    
    
    
    
    // UIDesign
    
    func setLabelColor(){
        var color = Colors.dark
        if AppDelegate.darkMode{
            color = Colors.light
            
        }
        
        self.netWorthLabel.textColor = color
        self.netWorth.textColor = color
        self.netWorthCent.textColor = color
        self.change.textColor = Colors.materialGreen
    }
    
    
    func setEmptyIndicator(){
        if let stocks = allStocksUnderWatch(){
            if stocks.count == 0{
                self.pendingOrderEmpty.isHidden = false
                self.newsEmpty.isHidden = false
                self.portfolioEmpty.isHidden = false
            } else {
                self.pendingOrderEmpty.isHidden = true
                self.newsEmpty.isHidden = true
                self.portfolioEmpty.isHidden = true
            }
        }
    }
    
    
    // MARK Uitableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let stocks = allStocksUnderWatch() {
            if stocks.count == 0{
                tableView.isHidden = true
                return 0
            } else {
                tableView.isHidden = false
                return stocks.count
            }
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockTableViewCell
        if let stocks = allStocksUnderWatch(){
            let stock = stocks[indexPath.row]
            if stock.status! == "following"{
                cell.configureStockCell(stock.name!, shares: "Following", price: 123.0)
            } else {
                cell.configureStockCell(stock.name!, shares: "12", price: 123.0)
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StockTableViewCell
        
        stockNameG = cell.stockName.text!
        performSegue(withIdentifier: "homeSegue", sender: self)
        
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StockTableViewCell
        cell.isSelected = false
        cell.isHighlighted = false
        
    }
    
    
    // MARK iCarousel
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if let view = Bundle.main.loadNibNamed("QuickNewsView", owner: self, options: nil)?[0]{
            return view as! QuickNewsView
        }
        let view1 = UIView()
        view1.backgroundColor = .red
        return view1
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 10
    }
    
    
    
    
}


