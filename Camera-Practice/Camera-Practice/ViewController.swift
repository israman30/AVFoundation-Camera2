//
//  ViewController.swift
//  Camera-Practice
//
//  Created by Israel Manzo on 8/15/17.
//  Copyright © 2017 Israel Manzo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate  {
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var cameraBtn: UIButton!
    
    let captureSession = AVCaptureSession()
    
    var captureDevice: AVCaptureDevice?
    
    var previewlayer: AVCaptureVideoPreviewLayer?
    
    var frontCamera = false
    
    var takePhoto = true
    
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        cameraBtn.layer.borderWidth = 5
        cameraBtn.layer.borderColor = UIColor.white.cgColor
        cameraBtn.layer.cornerRadius = 30
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        cameraFront(frontCamera)
        
        if captureDevice != nil {
            startSession()
        }
        
    }
    
    // MARK: - Camera Strat Session
    func startSession(){
        previewlayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.layer.addSublayer(previewlayer!)
        previewlayer?.frame = self.cameraView.layer.bounds
        previewlayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureSession.startRunning()
        stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
    }
    
    // MARK: - Camera Session
    func cameraFront(_ front: Bool){
        
        let devices = AVCaptureDevice.devices()
        
        do {
            try captureSession.removeInput(AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print(error.localizedDescription)
        }
        
        for device in devices! {
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)){
                if frontCamera {
                    if (device as AnyObject).position == AVCaptureDevicePosition.front {
                        captureDevice = device as? AVCaptureDevice
                        
                        do {
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                        } catch {
                            print(error.localizedDescription)
                        }
                        break
                    }
                } else {
                    if (device as AnyObject).position == AVCaptureDevicePosition.back {
                        captureDevice = device as? AVCaptureDevice
                        
                        do {
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                        } catch {
                            print(error.localizedDescription)
                        }
                        break
                    }
                }
            }
        }
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        getImage()
    }
    
    // MARK: - Take a photo function
    func getImage(){
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                let image = UIImage(data: imageData!)
                UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                self.cameraView.backgroundColor = UIColor(patternImage: image!)
//                let imageView = UIImageView(image: image)
//                imageView.frame = self.cameraView.frame
//                self.cameraView.addSubview(imageView)
            })
        }
    }
    
    // MARK: - Open Camera Flash function
    @IBAction func cameraFlash(_ sender: Any) {
        
        if captureDevice!.hasTorch {
            
            do {
                try captureDevice?.lockForConfiguration()
                captureDevice!.torchMode = captureDevice!.isTorchActive ? AVCaptureTorchMode.off : AVCaptureTorchMode.on
                captureDevice!.unlockForConfiguration()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Switch Front-Back Camera
    @IBAction func switchCamera(_ sender: Any) {
        frontCamera = !frontCamera
        captureSession.beginConfiguration()
        
        let inputs = captureSession.inputs as! [AVCaptureInput]
        
        for oldInput: AVCaptureInput in inputs {
            captureSession.removeInput(oldInput)
        }
        cameraFront(frontCamera)
        
        self.captureSession.commitConfiguration()
        
    }
    

}

