//
//  ViewController.swift
//  LocalizablesOrganizer
//
//  Created by OLX - Federico Jordan on 9/8/16.
//  Copyright © 2016 OLX - Federico Jordan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var sourceScrollView: NSScrollView!
    @IBOutlet weak var numberOfSectionsTextField: NSTextField!
    @IBOutlet weak var numberOfSentencesTextField: NSTextField!
    
    var sectionsStringArray = [String]()
    var keysStringsArray = [String]()
    var firstText = ""
    
    ///Disabled, don't know why get sections button dealock
    let checkForFirstText = false
    
    ///Maybe would be better into a plist
    let orderedSectionsHeadersArray = ["//MARK: - Login",
                                "//MARK: - Common Errors",
                                "//MARK:- Alerts",
                                "//MARK: - Home",
                                "//MARK: -- Location not allowed",
                                "//MARK: - Banner",
                                "//MARK: - Search",
                                "//MARK: - Product",
                                "//MARK: -- Delete and report ad",
                                "//MARK: - Edit item",
                                "//MARK: - Mark as Sold",
                                "//MARK: - Posting",
                                "//MARK: -- Posting Fields",
                                "//MARK: -- Posting Local posting errors",
                                "//MARK: -- Posting Message Header",
                                "//MARK: - Edit Profile",
                                "//MARK: - Profile",
                                "//MARK: -- Other's profile",
                                "//MARK: -- Your profile",
                                "//MARK: - Followers (Network)",
                                "//MARK: -- Followers Empty States",
                                "//MARK: - Mutual Friends Card",
                                "//MARK: - Report user/product",
                                "//MARK: - Item status",
                                "//MARK: - Chat",
                                "//MARK: - Make an offer",
                                "//MARK: - Onboarding",
                                "//MARK: - Rate Alert",
                                "//MARK:- Photo gallery",
                                "//MARK:- No Network",
                                "//MARK:- Push notification reminder",
                                "//MARK:- Find friends",
                                "//MARK: - Users Found",
                                "//MARK:- Notification Center"]
}

//MARK:- Actions
extension ViewController{
    @IBAction func didTapGetSections(sender: AnyObject) {
        print("didTapGetSections")
        
        if let sourceTextView = sourceScrollView.documentView as? NSTextView, sourceText = sourceTextView.textStorage{
//            print("sourceText: \(sourceText)")
            
            //Validate localizable file
            if validateText(sourceText) == false{
                return
            }
            
            //Get previous sections text
            getPreviousSectionsText(sourceText)
            
            //Get sections
            splitTextInSections(sourceText)
        }
        
        print("finish")
    }

    @IBAction func didTapSort(sender: AnyObject) {
        sortAndSetText()
    }
}

//MARK:- Utils
extension ViewController{
    ///Shows an alert telling that the file format is not correct
    func showErrorAlert(){
        showAlert("The localizable file format is not correct", title: "Error")
    }
    
    ///Shows a custom alert with title and message
    func showAlert(message: String, title: String){
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButtonWithTitle("OK")
        alert.alertStyle = NSAlertStyle.WarningAlertStyle
        alert.beginSheetModalForWindow(self.view.window!, completionHandler: nil)
    }
    
    ///Validate the text to analize
    func validateText(sourceText: NSTextStorage) -> Bool{
        var validateFirstText = true
        if checkForFirstText{
            validateFirstText = sourceText.string.rangeOfString("*/") != nil
        }
        if sourceText.string.rangeOfString("//MARK") == nil && validateFirstText {
            showErrorAlert()
            return false
        }
        return true
    }
    
    ///Get the first text (file name, author, project headers)
    func getPreviousSectionsText(sourceText: NSTextStorage){
        if checkForFirstText == false{
            return
        }
        
        var actualCharacter = sourceText.characters.first?.string
        var actualCharacterIndex = 0
        
        while firstText.rangeOfString("*/") == nil{
            firstText += actualCharacter!
            actualCharacterIndex += 1
            actualCharacter = sourceText.characters[actualCharacterIndex].string
            print("firstText: \(firstText)")
            
        }
        firstText += "/\n\n"
        print("firstText: \(firstText)")
    }
    
    ///Gets the localizables sections
    func splitTextInSections(sourceText: NSTextStorage){
        sectionsStringArray = [String]()
        
        var sentencesArray = [String]()
        var actualSection = ""
        
        var actualString = ""
        
        let restText = sourceText.string.stringByReplacingOccurrencesOfString(firstText, withString: "")
        let restTextStorage = NSTextStorage(string: restText)
        
        print("sourceText.characters.count: \(restTextStorage.characters.count)")
        for character in restTextStorage.characters{
            //                                print("character: \(character)")
            actualString += character.string
            
            if character.string == "\n"{
                //                    print("actualString: \(actualString)")
                
                if actualString != "\n"{
                    if actualString.rangeOfString("//MARK") != nil{
                        actualSection = sortedSection(actualSection)
                        sectionsStringArray.append(actualSection)
                        actualSection = actualString
                    }
                    else{
                        actualSection += actualString
                        sentencesArray.append(actualString)
                      
                        validateSentence(actualString)
                    }
                }
                
                actualString = ""
            }
            
        }
        
        //Last section
        actualSection += actualString
        sentencesArray.append(actualString)
        sectionsStringArray.append(actualSection)
        actualSection = ""
        
        print("total number of sentences: \(sentencesArray.count)")
        numberOfSentencesTextField.stringValue = "Number of sentences: \(sentencesArray.count)"
        print("total number of sections: \(sectionsStringArray.count)")
        numberOfSectionsTextField.stringValue = "Number of sections: \(sectionsStringArray.count)"
    }
    
    ///Sorts a section string alphabetically
    func sortedSection(section: String) -> String{
        var sentencesArray = section.componentsSeparatedByString("\n")
        let headerString = sentencesArray[0]
        let sortedSentences = sentencesArray.sort()
        
        var sortedSection = headerString
        
        for sentence in sortedSentences{
            if sentence != headerString{
                sortedSection += sentence
                sortedSection += "\n"
            }
        }
        
        return sortedSection
    }
    
    ///Sorts and set the new localizable text
    func sortAndSetText(){
        var orderedText = firstText
        
        for header in orderedSectionsHeadersArray{
            print("header to search: \(header)")
            for section in sectionsStringArray{
                if section.rangeOfString(header) != nil{
                    orderedText += section
                    orderedText += "\n"
                }
            }
        }
        
        if let sourceTextView = sourceScrollView.documentView as? NSTextView{
            sourceTextView.string = orderedText
            sourceTextView.textColor = NSColor.blackColor()
            sourceTextView.font = NSFont(name: "Menlo", size: 12.0)
        }
    }
    
    func validateSentence(sentence: String){
        if sentence.rangeOfString("//") != nil && sentence.rangeOfString("\"") == nil{
            if sentence.rangeOfString("MARK") == nil{
                showAlert("There is a missing MARK on line: \(sentence)", title: "Format error")
            }
        }
        else{
            if sentence.rangeOfString(";") == nil{
                showAlert("There is a missing ; on line: \(sentence)", title: "Format error")
            }
            else if sentence.rangeOfString("\";") == nil{
                showAlert("There is a missing \" on line: \(sentence)", title: "Format error")
            }
            else{
                let key = getKey(fromSentence: sentence)
                if key == ""{
                    showAlert("Not found key in line: \(sentence)", title: "Format error")
                }
                else{
                    if keysStringsArray.contains(key){
                        showAlert("Key duplicated in line: \(sentence)", title: "Format error")
                    }
                    keysStringsArray.append(key)
                }
            }
        }
    }
    
    func getKey(fromSentence sentence: String) -> String{
        let stringsArray = sentence.componentsSeparatedByString("\"")
        if stringsArray.count>0{
            return stringsArray[1] ?? ""
        }
        return ""
    }
}

