//
//  ViewController.swift
//  Project 10-12
//
//  Created by Dmitrii Vrabie on 23.02.2024.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard

        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
            } catch {
                print("Failed to load people")
            }
        }
        title = "Foto Table"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as? Cell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        let picture = pictures[indexPath.item]
        
        cell.buttonClick = {
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            let acc = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                picture.name = newName
                tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(acc)
            self.present(ac, animated: true)
           
        }
        save()
        cell.textLabelRow.text = picture.name
        
        let path = getDocumentsDirectory().appendingPathComponent(picture.image)
        cell.imageRow.image = UIImage(contentsOfFile: path.path)
        cell.imageRow.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageRow.layer.borderWidth = 2
        cell.imageRow.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
   
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let picture = pictures[indexPath.row]
            vc.selectedImage = picture
            navigationController?.pushViewController(vc, animated: true)
            save()
        }
    }
    
    @objc func addNewImage() {
        let myAlert = UIAlertController(title: "Select library or camera", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .camera
            self.present(picker, animated: true)
        }
        let library = UIAlertAction(title: "Library", style: .default) { (action) in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        }
        myAlert.addAction(library)
        myAlert.addAction(camera)
        present(myAlert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let photo = Picture(image: imageName, name: "Unknown")
        pictures.append(photo)
        tableView.reloadData()
        dismiss(animated: true)
        
        save()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save people.")
        }
    }
}
