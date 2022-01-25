//
//  CreateNoteView.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 21/01/2022.
//

import UIKit

protocol CreateNoteViewProtocol: AnyObject {
    func send(note: Note)
}

class CreateNoteView: UIView, UITextViewDelegate, UITextFieldDelegate {

    var savedNote: Note? {
        didSet {
            if savedNote == nil {
                noteTitle.text = "Note title"
                noteTitle.textColor = UIColor.lightGray
                noteContent.text = "Type something interesting..."
                noteContent.textColor = UIColor.lightGray
            } else {
                noteTitle.text = savedNote!.title
                noteTitle.textColor = UIColor.black
                noteContent.text = savedNote!.content
                noteContent.textColor = UIColor.black
            }
        }
    }
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
    weak var delegate: CreateNoteViewProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        noteTitle.delegate = self
        noteContent.delegate = self
    }
    
    func commonInit() {
        
        let viewFromXib = Bundle.main.loadNibNamed("CreateNoteView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func cancelButtonTapped(_ UIButton: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func saveButtonTapped(_ UIButton: Any) {
        var note = Note(title: noteTitle!.text!, content: noteContent!.text, row: nil)
        if savedNote != nil {
            note.row = savedNote!.row
        }
        self.delegate.send(note: note)
        self.removeFromSuperview()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = UIColor.black
        }
    }
}