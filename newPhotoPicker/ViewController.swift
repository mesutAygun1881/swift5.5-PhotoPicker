//
//  ViewController.swift
//  newPhotoPicker
//
//  Created by Mesut Aygün on 17.06.2021.
//

import UIKit
import Photos
import PhotosUI

class ViewController: UIViewController, PHPickerViewControllerDelegate, UICollectionViewDataSource {
 
    
   
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200 , height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .yellow
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Picker"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClick))
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.frame = view.bounds
    }
    @objc func addButtonClick() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 3
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let group = DispatchGroup()
        
        results.forEach { result in
            group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                    defer{
                        group.leave()
                    }
                guard let image = reading as? UIImage , error == nil else {
                    return
                }
                self?.images.append(image)
           
            }
        }
        group.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
    private var images = [UIImage]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell else {fatalError()}
        cell.imageView.image = images[indexPath.row]
        return cell
    }


}

