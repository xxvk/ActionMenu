//
//  ViewController.swift
//  ActionMenuExample
//
//  Created by 樊半缠 on 16/8/11.
//  Copyright © 2016年 reformation.tech All rights reserved.
//

import UIKit
import ActionMenu

class ViewController: UIViewController {

    @IBAction func left_Navi_Click(_ sender: UIButton) {
        let menu = ActionMenu.init(actions: self.actions, direction: UIMenuControllerArrowDirection.left, inView: sender)
        
        menu.show(animated: true, handler: { () in
            
        })
    }
    @IBAction func middle_Navi_Click(_ sender: UIButton) {
        let menu = ActionMenu.init(actions: self.actions, direction: nil, inView: sender)
        
        menu.show(animated: true, handler: { () in
            
        })
    }
    @IBAction func right_Navi_Click(_ sender: UIButton) {
        let menu = ActionMenu.init(actions: self.actions, direction: UIMenuControllerArrowDirection.right, inView: sender)
        
        menu.show(animated: true, handler: { () in
            
        })
    }
    /* ActionLabel implement an example of ActionMenu for UI-Extension inside */
    @IBOutlet var label: ActionLabel!
    /* Normal Elements */
    @IBOutlet var textField: UITextField!
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var tableView: UITableView!
    
    
    //  MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewController", for: indexPath)
        cell.textLabel?.text = "title"
        cell.detailTextLabel?.text = "details"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        let menu = ActionMenu.init(actions: self.actions, direction: nil, inView: cell!.contentView)
        
        menu.show(animated: true, handler: { () in
            
        })
    }
}
extension ViewController: ActionableProtocol {
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        //        (foo,bar, baz, qux, quux, corge,grault, garply, waldo, fred, plugh, xyzzy, thud)
        let foo = (action == #selector(self.copyText))
        
        if foo{
            return true
        }
        return false
    }
    
    var actions: [UIMenuItem]{
        get{
            let foo = UIMenuItem.init(title: "Copy", action: #selector(self.copyText))
            return [foo]
        }
    }
    
    func copyText() -> Void {
        let indexPath = self.tableView.indexPathForSelectedRow
        if indexPath != nil {
            let cell = self.tableView.cellForRow(at: indexPath!)
            
            UIPasteboard.general.string = cell?.detailTextLabel!.text
            
            let alert = UIAlertController.init(title: "Pasteboard did save String:", message: cell?.detailTextLabel!.text, preferredStyle: UIAlertControllerStyle.alert)
            
            self.present(alert, animated: true, completion: {
                
                let delay = Int64.init(NSEC_PER_SEC * 1)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC), execute: {
                    alert.dismiss(animated: true, completion: nil)
                })
                
            })
        }
    }
}


