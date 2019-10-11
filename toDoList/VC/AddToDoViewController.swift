//
//  AddToDoViewController.swift
//  toDoList
//
//  Created by Dima Khymych on 11.10.2019.
//  Copyright © 2019 Dima Khymych. All rights reserved.
//

import UIKit
import CoreData

class AddToDoViewController: UIViewController {

    //MARK: - Properties
    
    var managedContext: NSManagedObjectContext!
    var todo: ToDo?
    
    
    //MARK: Outlets
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)) ,
            name: UIResponder.keyboardWillShowNotification  ,
            object: nil)
        textView.becomeFirstResponder()
        
        if let todo = todo {
            textView.text = todo.title
            textView.text = todo.title
            segmentedControl.selectedSegmentIndex = Int(todo.priority)
            
        }
        
        
        
    }
    
    
    
    
    // MARK: Actions
    @objc func keyboardWillShow(with notification: Notification) {
        
       let key = "UIKeyboardFrameEndUserInfoKey"
        
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        
        let keyboardHight = keyboardFrame.cgRectValue.height + 10
        
        bottomConstraint.constant = keyboardHight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        
        
    }

    fileprivate func dismissAndResign() {
        dismiss(animated: true)
        textView.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        dismissAndResign()
    }
    
    @IBAction func done(_ sender: UIButton) {
        
        guard let title = textView.text, !title.isEmpty else {return}
        
        if let todo = self.todo{
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
        } else {
            
            let todo = ToDo(context: managedContext)
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
            todo.date = Date()
        }
        do {
            
            try managedContext.save()

            dismissAndResign()
            
        } catch {
            
            print("Error saving todo: \(error)")
        }
    
    }
}

extension AddToDoViewController: UITextViewDelegate{
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if doneButton.isHidden {
            textView.text.removeAll()
            textView.textColor = UIColor.white
            
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
