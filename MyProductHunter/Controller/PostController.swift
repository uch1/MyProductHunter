//
//  ViewController.swift
//  MyProductHunter
//
//  Created by Fernando on 9/20/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

class PostController: UIViewController {
    
    var posts = [Post]() {
        didSet{
            postsTable.reloadData()
        }
    }
    
//    var posts = [Post]()
    @IBOutlet weak var postsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        postsTable.dataSource = self
        postsTable.delegate = self
        
        postsTable.rowHeight = UITableViewAutomaticDimension
        postsTable.estimatedRowHeight = 100
        
        ProductService.getFeaturedProducts { (posts) in
            guard let postList = posts else {return}
            self.posts = postList
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PostController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTable.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = posts[indexPath.row]
        cell.configureCell(post: post)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        performSegue(withIdentifier: "ViewComments", sender: post)
    }
}

extension PostController: UITableViewDelegate {
    
}

extension PostController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewComments" {
            if let destinationVC = segue.destination as? CommentsController{
                if let post = sender as? Post {
                    destinationVC.post = post
                }
            }
        }
    }
}

