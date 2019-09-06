//
//  PeopleViewController.swift
//  PeopleAndAppleStockPrices
//
//  Created by Liana Norman on 9/5/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var peopleTableView: UITableView!
    
    
    // MARK: Properties
    var peopleModel = [Person]()
    
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
        loadData()
    }
    
    // MARK: Private Methods
    private func loadData() {
        guard let pathToJSONFile = Bundle.main.path(forResource: "userinfo", ofType: "json") else {
            fatalError("Could not find JSON file")
        }
        let url = URL(fileURLWithPath: pathToJSONFile)
        do {
          let data = try Data(contentsOf: url)
            let peopleFromJSON = People.getUsers(from: data)
            peopleModel = peopleFromJSON.sorted(by: {$0.name.description < $1.name.description})
        } catch {
            fatalError()
        }
    }
    
    // MARK: Navigation Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetailPeople" {
            guard let detailPeopleVC = segue.destination as? DetailPeopleViewController else {
                fatalError()
            }
            guard let selectedIndexPath = peopleTableView.indexPathForSelectedRow else {
                fatalError()
            }
            detailPeopleVC.person = peopleModel[selectedIndexPath.row]
        }
    }
    
    
}


// MARK: Extensions

extension PeopleViewController: UITableViewDelegate {
    
}


extension PeopleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath)
        cell.textLabel?.text = peopleModel[indexPath.row].name.description
        cell.detailTextLabel?.text = peopleModel[indexPath.row].location.city
        return cell
    }
}
