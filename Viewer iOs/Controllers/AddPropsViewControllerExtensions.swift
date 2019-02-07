//
//  AddPropsViewControllerExtensions.swift
//  Viewer
//
//  Created by Gianluca Orpello on 07/02/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## Extension needed for the table view implementation.

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
extension AddPropsViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - UITableView Delegate

    /**
     ## UITableView Delegate - heightForRowAt Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch props.title {
        case Categories.globalMessage.rawValue:
            switch indexPath.section {
            case 0:
                return 235
            case 1:
                return 75
            case 2:
                if indexPath.row == 2 {
                    return 125
                } else {
                    return 44
                }
            case 3:
                if locationPickerIsVisible && indexPath.row == 2 {
                    return 217
                } else if !locationPickerIsVisible && indexPath.row == 2 {
                    return 0
                } else if datePickerIsVisible && indexPath.row == 4 {
                    return 217
                } else if !datePickerIsVisible && indexPath.row == 4 {
                    return 0
                } else {
                    return 50
                }
            default:
                return 0
            }
        case Categories.tickerMessage.rawValue:
            switch indexPath.section {
            case 0:
                return 235
            case 1, 2:
                return 60
            default:
                return 0
            }
        case Categories.keynoteViewer.rawValue:
            switch indexPath.section {
            case 0:
                return 235
            case 1:
                return 115
            case 2:
                return 44
            default:
                return 0
            }
        default:
            return 0
        }
    }

    /**
     ## UITableView Delegate - titleForHeaderInSection Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section != 1 else { return "Description" }

        switch props.title {
        case Categories.globalMessage.rawValue:
            switch section {
            case 2:
                return "Text"
            case 3:
                return "Detail"
            default:
                return nil
            }
        case Categories.tickerMessage.rawValue:
            switch section {
            case 2:
                return "Text"
            default:
                return nil
            }
        case Categories.keynoteViewer.rawValue:
            switch section {
            case 2:
                return "File"
            default:
                return nil
            }
        default:
            return nil
        }
    }

    /**
     ## UITableView Delegate - didSelectRowAt Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard props.title == Categories.globalMessage.rawValue,
            indexPath.section == 3,
            indexPath.row == 1 else { return }

        toggleShowLocationDatepicker()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - UITableView Data Source

    /**
     ## UITableView Data Source - numberOfSections Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        switch props.title {
        case Categories.globalMessage.rawValue:
            return 4
        case Categories.tickerMessage.rawValue:
            return 3
        case Categories.keynoteViewer.rawValue:
            return 3
        default:
            return 0
        }
    }

    /**
     ## UITableView Data Source - numberOfRowsInSection Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section != 0, section != 1 else { return 1 }

        switch props.title {
        case Categories.globalMessage.rawValue:
            if section == 2 {
                return 3
            } else if section == 3 {
                return 5
            } else {
                return 0
            }
        case Categories.tickerMessage.rawValue:
            return 2
        case Categories.keynoteViewer.rawValue:
            return 1
        default:
            return 0
        }
    }

    /**
     ## UITableView Data Source - cellForRowAt Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {

            if let cell = tableView.dequeueReusableCell(withIdentifier: "FullImageTableViewCell") as? FullImageTableViewCell {
                cell.fullImage = UIImage(named: props.title)
                return cell
            } else { return UITableViewCell() }

        } else {

            switch props.title {
            // MARK: Global Message
            case Categories.globalMessage.rawValue:

                switch indexPath.section {
                case 1:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "FullLightTextTableViewCell") as? FullLightTextTableViewCell{

                        cell.fullText = "Displays a message with a title and description attached with location, date, time and a link displayed as a QR code."
                        return cell
                    } else { return UITableViewCell() }

                case 2:
                    switch indexPath.row {
                    case 0:

                        if let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell{

                            cell.placeholderText = "Title"
                            cell.delegate = self

                            return cell
                        } else { return UITableViewCell() }

                    case 1:

                        if let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell{

                            cell.placeholderText = "Description"
                            cell.delegate = self

                            return cell
                        } else { return UITableViewCell() }

                    case 2:

                        if let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell{

                            cell.placeholderText = "Message"
                            cell.delegate = self

                            return cell
                        } else { return UITableViewCell() }


                    default:
                        return UITableViewCell()
                    }
                case 3:

                    switch indexPath.row {
                    case 0:

                        if let cell = tableView.dequeueReusableCell(withIdentifier: "LabelAndTextfieldTableViewCell") as? LabelAndTextfieldTableViewCell{

                            cell.titleText = "URL"
                            cell.delegate = self
                            cell.placeholderText = "https://example.com"

                            return cell
                        } else { return UITableViewCell() }

                    case 1:

                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MasterAndDetailLabelsTableViewCell") as? MasterAndDetailLabelsTableViewCell{

                            cell.mainText = "Location"
                            cell.detailText = selectedLocation.rawValue

                            return cell
                        } else { return UITableViewCell() }
                    case 2:
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none

                        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 217))
                        picker.delegate = self
                        picker.dataSource = self
                        picker.isHidden = !locationPickerIsVisible

                        cell.contentView.addSubview(picker)
                        return cell
                    case 3:

                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MasterDetailLabelsAndSwitchTableViewCell") as? MasterDetailLabelsAndSwitchTableViewCell {

                            cell.mainText = "Date & Time"
                            cell.isSwitchOn = datePickerIsVisible
                            cell.addTarget(self, action: #selector(openOrCloseDatePicker))
                            cell.detailText = cell.isSwitchOn! ? getCurrent(date: Date()) : "None"
                            return cell
                        } else { return UITableViewCell() }
                    case 4:

                        let cell = UITableViewCell()
                        cell.selectionStyle = .none

                        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 217))
                        picker.datePickerMode = .dateAndTime
                        picker.isHidden = !datePickerIsVisible
                        picker.addTarget(self, action: #selector(dateDidChange(sender:)), for: .valueChanged)

                        cell.contentView.addSubview(picker)
                        return cell

                    default:
                        return UITableViewCell()
                    }
                default:
                    return UITableViewCell()
                }

            // MARK: Ticker Message
            case Categories.tickerMessage.rawValue:
                switch indexPath.section {

                case 1:

                    if let cell = tableView.dequeueReusableCell(withIdentifier: "FullLightTextTableViewCell") as? FullLightTextTableViewCell{
                        cell.fullText = "Displays a short message always visible at the bottom of the screen."
                        return cell
                    } else { return UITableViewCell() }

                case 2:
                    if indexPath.row == 0 {
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell{

                            cell.delegate = self
                            cell.placeholderText = "Message"
                            return cell
                        } else { return UITableViewCell() }
                    } else {
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "FullLightTextTableViewCell") as?
                            FullLightTextTableViewCell {
                            //                            label.tag = 150
                            cell.fullText = "\(numberOfChar) characters left"

                            return cell
                        } else { return UITableViewCell() }
                    }
                default:
                    return UITableViewCell()
                }

            // MARK: Content Viewer
            case Categories.keynoteViewer.rawValue:
                switch indexPath.section {
                case 1:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "FullLightTextTableViewCell") as? FullLightTextTableViewCell{

                        cell.fullText = "Displays an image or a file that covers most of the screen. Use a content with a transparent background to get the Viewer overlay. Prefer 16:9 PNG files. You can also use the share extension inside other apps like Keynote, Photos or Files."
                        return cell
                    } else { return UITableViewCell() }

                case 2:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredButtonTableViewCell") as? CenteredButtonTableViewCell{
                        cell.title = "Select Content"
                        cell.titleColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
                        cell.horizontalAlignment = .left
                        cell.addTarget(self, action: #selector(getContentViewer))
                        return cell
                    } else { return UITableViewCell() }
                default:
                    return UITableViewCell()
                }
            default:
                return UITableViewCell()
            }
        }
    }
}


/**
 ## Extension for UITextFieldDelegate implementation.

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
extension AddPropsViewController: UITextFieldDelegate {

    /**
     ## UITextFieldDelegate - textFieldShouldReturn Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let textFields = [tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.viewWithTag(500) as? UITextField,
                          tableView.cellForRow(at: IndexPath(row: 1, section: 2))?.viewWithTag(500) as? UITextField,
                          tableView.cellForRow(at: IndexPath(row: 2, section: 2))?.viewWithTag(500) as? UITextField]

        switch self.title {
        case Categories.globalMessage.rawValue:

            if let index = textFields.index(of: textField){
                if let nextTextField = textFields[index + 1] {
                    nextTextField.becomeFirstResponder()
                }
            }

        default:
            textField.endEditing(true)
        }

        tableView.setContentOffset(CGPoint.zero, animated: true)
        return true
    }

    /**
     ## UITextFieldDelegate - shouldChangeCharactersIn Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {


        guard let text = textField.text, textField.tag == 500 else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            return false

        }
        let newLength = text.count + string.count - range.length

        if newLength == 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        numberOfChar = 70 - newLength
        return numberOfChar > 0 ? true : false
    }

    /**
     ## UITextFieldDelegate - textFieldDidBeginEditing Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.title == Categories.globalMessage.rawValue {
            tableView.setContentOffset(CGPoint(x: 0, y: textField.center.y + 100), animated: true)
        }
    }
}

// MARK: - Extension for UIPickerController
extension AddPropsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - UIPickerView Delegate

    /**
     ## UIPickerViewDelegate - titleForRow Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Locations.allCases[row].rawValue
    }

    /**
     ## UIPickerViewDelegate - didSelectRow Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLocation = Locations.allCases[row]
    }

    // MARK: - UIPickerView Data Source

    /**
     ## UIPickerViewDataSource - numberOfComponents Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    /**
     ## UIPickerViewDataSource - numberOfRowsInComponent Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Locations.allCases.count
    }
}

extension AddPropsViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)

        let story = UIStoryboard(name: "Main", bundle: nil)
        if let destination = story.instantiateViewController(withIdentifier: "SetsViewController") as? TvListViewController {
            for url in urls {
                do {
                    let data = try Data(contentsOf: url)
                    destination.keynote?.append(UIImage(data: data)!)
                    destination.category = .keynoteViewer
                    self.navigationController?.pushViewController(destination, animated: true)
                } catch {
                    NSLog("Error on getting data - AddPropsViewController: didPickDocumentsAt")
                }
            }
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddPropsViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        let story = UIStoryboard(name: "Main", bundle: nil)
        if let destination = story.instantiateViewController(withIdentifier: "SetsViewController") as? TvListViewController {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                destination.keynote = [image.byFixingOrientation()]
                destination.category = .keynoteViewer
            }
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
