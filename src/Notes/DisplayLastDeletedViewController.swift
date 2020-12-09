//
//  DisplayLastDeletedViewController.swift
//  Notes
//
//  Created by Jarrett Zapata on 12/8/20.
//  Copyright © 2020 SFSU. All rights reserved.
//

import UIKit

class DisplayLastDeletedViewController: UIViewController {
    
    var archiveNote: ArchiveNote?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let note = archiveNote {
            titleTextField.text = note.title
            contentTextView.text = note.content
        } else {
            titleTextField.text = ""
            contentTextView.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }

        switch identifier {
        case "resave" where archiveNote != nil:
            let note = CoreData.newNote()
            note.title = titleTextField.text ?? ""
            note.content = contentTextView.text ?? ""
            note.lastModTime = Date()
            
            CoreData.saveNote()

        case "resave" where archiveNote == nil:
            let note = CoreData.newNote()
            note.title = titleTextField.text ?? ""
            note.content = contentTextView.text ?? ""
            note.lastModTime = Date()

            CoreData.saveNote()

        default:
            print("unexpected segue")
        }
    }
    
}
