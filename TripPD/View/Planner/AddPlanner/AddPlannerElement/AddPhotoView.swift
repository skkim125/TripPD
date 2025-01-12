//
//  AddPhotoView.swift
//  TripPD
//
//  Created by 김상규 on 9/14/24.
//

import SwiftUI
import PhotosUI

struct AddPhotoView: UIViewControllerRepresentable {
    @Binding var showPHPickeView: Bool
    var completionHandler: (Data) async -> ()
    
    func makeUIViewController(context: Context) -> some PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let view = PHPickerViewController(configuration: config)
        view.delegate = context.coordinator
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: PHPickerViewControllerDelegate {
    private let parent: AddPhotoView
    
    init(_ parent: AddPhotoView) {
        self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        guard let select = results.first else { return }
        select.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            guard let self = self else { return }
            if let image = object as? UIImage {
                guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
                Task {
                    await self.parent.completionHandler(imageData)
                }
            }
        }
    }
}

#Preview {
    AddPhotoView(showPHPickeView: .constant(true)) { image in
        print(image)
    }
}
