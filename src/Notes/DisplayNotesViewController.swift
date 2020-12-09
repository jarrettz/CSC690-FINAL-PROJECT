//
//  DisplayNotesViewController.swift
//  Notes
//
//  Created by Jarrett Zapata on 12/8/20.
//  Copyright © 2020 SFSU. All rights reserved.
//

import UIKit

class DisplayNoteViewController: UIViewController {
    
    var note: Note?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let note = note {
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
        case "save" where note != nil:
            note?.title = titleTextField.text ?? ""
            note?.content = contentTextView.text ?? ""
            note?.lastModTime = Date()

            CoreData.saveNote()

        case "save" where note == nil:
            let note = CoreData.newNote()
            note.title = titleTextField.text ?? ""
            note.content = contentTextView.text ?? ""
            note.lastModTime = Date()

            CoreData.saveNote()

        case "cancel":
            print("cancel button pressed")

        default:
            print("unexpected segue")
        }
    }
}
