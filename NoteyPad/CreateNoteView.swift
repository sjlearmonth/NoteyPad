//
//  CreateNoteView.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 21/01/2022.
//

import UIKit

protocol CreateNoteViewProtocol: AnyObject {
    func send(title: String, content: String)
}

class CreateNoteView: UIView, UITextViewDelegate {

    var savedNoteTitle: String? {
        didSet {
            if savedNoteTitle == nil {
                noteTitle.text = "Note title"
            } else {
                noteTitle.text = savedNoteTitle
            }
        }
    }
    var savedNoteContent: String? {
        didSet {
            if savedNoteContent == nil {
                noteContent.text = "Type something interesting..."
            } else {
                noteContent.text = savedNoteContent
            }
        }
    }
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
    weak var delegate: CreateNoteViewProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
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
        let title = noteTitle.text ?? "No Title"
        let content = noteContent.text ?? "No Content"
        self.delegate.send(title: title, content: content)
        self.removeFromSuperview()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
