//
//  ViewController.swift
//  Notes
//
//  Created by Jarrett Zapata on 12/8/20.
//  Copyright © 2020 SFSU. All rights reserved.
//

import UIKit

class ListNotesTableViewController: UITableViewController {

    var notes = [Note]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var deletedNotes = [ArchiveNote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notes = CoreData.retrieveNotes()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listNotesTableViewCell", for: indexPath) as! TableViewCell

        let note = notes[indexPath.row]
        cell.noteTitleLabel.text = note.title
        cell.lastModTimeLabel.text = note.lastModTime?.convertToString() ?? "unknown"

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }

        switch identifier {
        case "displayNote":
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let note = notes[indexPath.row]
            let destination = segue.destination as! DisplayNoteViewController
            destination.note = note

        case "addNote":
            print("plus button pressed")

        case "toDeleted":
            if deletedNotes.isEmpty {
                let myMessage = "There is no recently deleted note"

                let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)

                myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                self.present(myAlert, animated: true, completion: nil)
            } else {
                let destination = segue.destination as? DisplayLastDeletedViewController
                destination?.archiveNote = deletedNotes[0]
            }
            
        default:
            print("unexpected segue")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteToDelete = notes[indexPath.row]
            deletedNotes.removeAll()
            let deletedNote = ArchiveNote()
            deletedNote.title = noteToDelete.title!
            deletedNote.content = noteToDelete.content!
            deletedNote.modificationTime = noteToDelete.lastModTime!
            deletedNotes.append(deletedNote)
            
            CoreData.delete(note: noteToDelete)
            
            notes = CoreData.retrieveNotes()
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        notes = CoreData.retrieveNotes()
    }

}
