//
//  ViewController.swift
//  Demo-VisionFaceRecognition
//
//  Created by Kristina Gelzinyte on 8/13/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var takePhotoButton: UIButton!
    
    private var imageViewController: ImageViewController?
    
    // MARK: - Lifecycle functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    @IBAction func takePhotoAction(_ sender: Any) {
        let alert = setupImagePickerAlert()
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - View setup
    
    private func setupImagePickerAlert() -> UIAlertController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alert.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        alert.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    // MARK: - UIImagePickerControllerDelegate implementation
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if imageViewController == nil {
            imageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController
        }
        
        guard let imageViewController = self.imageViewController else { return }
        
        imageViewController.image = pickedImage
        present(imageViewController, animated: true, completion: nil)
    }
}

