//
//  ViewController.swift
//  test2
//
//  Created by Huy Vu on 10/9/23.
//

import UIKit
import AVFoundation
   

class ViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var captureButton: UIButton!

    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        captureSession.sessionPreset = .photo

        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices
        if !availableDevices.isEmpty {
            captureDevice = availableDevices.first
            beginSession()
        }

    }
    
    
    func beginSession() {
        do {
            guard let captureDevice = captureDevice else { return }

            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(deviceInput)

            photoOutput = AVCapturePhotoOutput()
            if captureSession.canAddOutput(photoOutput!) {
                captureSession.addOutput(photoOutput!)
            }

            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.videoOrientation = .portrait
            cameraView.layer.addSublayer(previewLayer)
            
            
            captureSession.startRunning()
        } catch {
            print("Lỗi khi thiết lập phiên máy ảnh: \(error.localizedDescription)")
        }
    }


    @IBAction func capturePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            if let image = UIImage(data: imageData) {
                // Xử lý ảnh đã chụp
                // Bạn có thể hiển thị nó, lưu nó vào thư viện ảnh hoặc thực hiện bất kỳ hành động nào khác ở đây
                // Đặt hình ảnh vào UIImageView
                imageSubview.image = image // Assign the UIImage object directly
                // Thêm UIImageView vào UIView
                cameraView.addSubview(imageSubview)
                
            }
        }
    }
}
