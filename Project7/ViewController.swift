//
//  ViewController.swift
//  Project7
//
//  Created by Pradeep Reddy Kypa on 21/06/21.
//

import UIKit

class ViewController: UITableViewController,UITextFieldDelegate {

    var petitions = [Petition]()
    var allPetitions = [Petition]()
    var filteredPetitions = [Petition]()
    var searchString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        var urlString = ""

        let tabBarItem = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action:#selector(self.onTapOfSearch))

        self.navigationItem.rightBarButtonItem = tabBarItem
        
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        if let url = URL.init(string: urlString) {

            URLSession.shared.dataTask(with: url) { responseData, response, error in

                if let data = responseData{
                    self.parseData(json: data)
                }else{
                    self.showError()
                }
            }.resume()

//            if let data = try? Data(contentsOf: url) {
//                parseData(json: data)
//                return
//            }
        }

//        showError()
    }

    @objc func onTapOfInfo(){

        let ac = UIAlertController.init(title: "Credits", message: "CopyRights to We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction.init(title: "Ok", style: .default))
        present(ac, animated: true)
    }

    @objc func onTapOfSearch(){

        let ac = UIAlertController.init(title: "Search", message: "Search your Petition", preferredStyle: .alert)

        ac.addTextField { textField in
            textField.placeholder = "Search Petition"
            textField.textAlignment = .center
            textField.delegate = self
        }

        let searchAction = UIAlertAction(title: "Search", style: .default){ _ in


            self.searchPetitions(searchString: self.searchString)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ _ in

            self.searchPetitions(searchString: "")
        }

        ac.addAction(searchAction)
        ac.addAction(cancelAction)

        present(ac, animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        searchString = textField.text ?? ""
    }

    func searchPetitions(searchString:String) {

        if !searchString.isEmpty {
            filterPetitions(searchString: searchString)
        }
        DispatchQueue.main.async(){
            self.tableView.reloadData()
        }
    }

    func filterPetitions(searchString:String){

        for petition in allPetitions {

            if (petition.title.contains(searchString) || petition.body.contains(searchString)) {

                filteredPetitions.append(petition)
            }
        }

    }

    func parseData(json: Data) {
        let jsonDecoder = JSONDecoder()

        if let jsonPetitions = try? jsonDecoder.decode(Petitions.self, from: json){

            allPetitions = jsonPetitions.results

            DispatchQueue.main.async(){

                self.tableView.reloadData()
            }
        }
    }

    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchString.isEmpty {
            return allPetitions.count
        }
        return filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        var petition:Petition?

        if !searchString.isEmpty {
            petition = filteredPetitions[indexPath.row]
        }else{
            petition = allPetitions[indexPath.row]
        }

        if let newPetition = petition {
            tableViewCell.textLabel?.text = newPetition.title
            tableViewCell.detailTextLabel?.text = newPetition.body
        }else{
            tableViewCell.textLabel?.text = ""
            tableViewCell.detailTextLabel?.text = ""
        }
        return tableViewCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

