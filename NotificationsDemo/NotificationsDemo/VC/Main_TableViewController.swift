//
//  Main_TableViewController.swift
//  NotificationsDemo
//
//  Created by Алексей Макаров on 11.01.2020.
//  Copyright © 2020 Алексей Макаров. All rights reserved.
//

import UIKit

class Main_TableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let arrayTitle = [
        "Local Notification",
        "Local Notification with Action",
        "Push Notification with Content",
        "Push Notification with APNs",
        "Push Notification with Firebase",
        "Push Notification with Content"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayTitle.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = arrayTitle[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        let notificationType = arrayTitle[indexPath.row]
        
        let alertVC = UIAlertController(title: notificationType, message: "After 5 seconds \(notificationType) will appear", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default) { [unowned self] (action) in
            self.appDelegate?.scheduleNotificaion(notificationType: notificationType)
        }
        
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = .black
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
