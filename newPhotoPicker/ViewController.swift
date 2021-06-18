//
//  ViewController.swift
//  newPhotoPicker
//
//  Created by Mesut Aygün on 17.06.2021.
//
/*PHPicker: Kullanıcının fotoğraf kitaplığındaki fotoğraflara ve videolara erişmenizi sağlayan, sistem tarafından sağlanan yeni bir seçici ekranı.

Kendi özel fotoğraf seçimi kullanıcı arayüzünüzü oluşturmak yerine bu seçiciyi kullanmanız önerilir.

Yeni sürüm şunları içerir:

yeni bir tasarım ve kullanımı kolay yeni API
entegre arama
kolay çoklu seçim
yakınlaştırma hareketi
PHPicker varsayılan olarak özeldir:

seçici ekranı işlem dışı kalıyor ve uygulamayla XPC aracılığıyla konuşuyor
uygulamanızın fotoğraf kitaplığına doğrudan erişimi yok
fotoğraf kitaplığı izni alması gerekmez ( gerçekten ihtiyacınız olmadıkça bunu istemeyin )
yanıt olarak yalnızca seçilen fotoğrafları ve videoları alırsınız
PHPicker, tek bir sınıfın adı değil, birlikte çalışan bir sınıflar kümesidir.

API'nin Öğeleri
PHPickerConfiguration – limitler ve filtreler belirlemenizi sağlar:

selectionLimit – seçilebilecek öğe sayısı (varsayılan olarak 1, 0 = sınırsız)
filter– örneğin .imagesveya.any(of: [.videos, .livePhotos])
PHPickerViewController – seçiciyi yöneten ana görünüm denetleyicisi:

seçici kendini otomatik olarak kapatmaz picker.dismiss(animated:), yanıtı aldığınızda arayın
PHPickerViewControllerDelegate – seçici için temsilci:

picker(_: didFinishPicking results:)
PHPickerResult – yanıt olarak bu nesnelerin bir dizisi uygulamaya iletilir

itemProvidersonuçtan almak
Kontrol itemProvider.canLoadObject(ofClass: UIImage.self)
aracılığıyla görüntüyü al itemProvider.loadObject(ofClass: UIImage.self) { … }
Normalde toplanan fotoğrafları çıkarabilir PHPickerResultdokunmadan madde sağlayıcıları PHPhotoLibraryhiç ama yine de fotoğraf kitaplığı erişmek için gereğini yaparsak, o zaman onu geçmek PHPickerConfiguration.initve almak assetIdentifierseçici sonuçlarından başvuruları.

PHPicker'ı fotoğraf kitaplığı erişimiyle kullanıyorsanız ve yalnızca bir fotoğraf alt kümesine sınırlı erişiminiz varsa, o zaman:

PHPicker, kullanıcının tüm kitaplığından fotoğraf seçmesine izin verecek
ancak doğrudan erişiminiz olan seçim, seçicide seçtikleri tarafından genişletilmeyecektir.
Fotoğraf kitaplığı API'leri UIImagePickerControllerkullanımdan kaldırılmıştır.*/

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
//       PHPickerConfiguration limitler ve filtreler belirlemenizi sağlar
        var config = PHPickerConfiguration(photoLibrary: .shared())
//        selectionLimit – seçilebilecek öğe sayısı (varsayılan olarak 1, 0 = sınırsız)
        config.selectionLimit = 3
//        filter– örneğin .images veya.any(of: [.videos, .livePhotos])
        config.filter = .images
        
//        PHPickerViewControllerDelegate – seçici için temsilci
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
//    picker(_: didFinishPicking results:)
//    PHPickerResult – yanıt olarak bu nesnelerin bir dizisi uygulamaya iletilir
    
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

