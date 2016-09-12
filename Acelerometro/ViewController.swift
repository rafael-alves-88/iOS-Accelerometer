//
//  ViewController.swift
//  Acelerometro
//
//  Created by Thales Toniolo on 10/18/14.
//  Copyright (c) 2014 FIAP. All rights reserved.
//
import UIKit
// Para trabalhar com acelerometro, o framework CoreMotion deve ser importada
import CoreMotion

class ViewController: UIViewController {

	let BallSpeed = 10.0
	let cmManager:CMMotionManager = CMMotionManager()

	@IBOutlet weak var xLabel: UILabel!
	@IBOutlet weak var yLabel: UILabel!
	@IBOutlet weak var zLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Adiciona a bolinha na tela
		let bolaImageView:UIImageView = UIImageView(image: UIImage(named: "bola"))
		bolaImageView.contentMode = UIViewContentMode.ScaleAspectFit
		bolaImageView.frame = CGRectMake(150, 150, 25, 25)
		self.view.addSubview(bolaImageView)

		// Configura o tempo de update do acelerometro
		self.cmManager.accelerometerUpdateInterval = (1.0 / 60.0) //60 fps
		// Registra um handler as acoes do acelerometro
		self.cmManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryCorrectedZVertical)
		self.cmManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (accelerometerData, error) -> Void in
			self.xLabel.text = "X: \(accelerometerData!.acceleration.x)"
			self.yLabel.text = "Y: \(accelerometerData!.acceleration.y)"
			self.zLabel.text = "Z: \(accelerometerData!.acceleration.z)"

			// Recupera os valores para x,y
			var novoX:CGFloat = bolaImageView.center.x + CGFloat(accelerometerData!.acceleration.x * self.BallSpeed)
			var novoY:CGFloat = bolaImageView.center.y - CGFloat(accelerometerData!.acceleration.y * self.BallSpeed)

			// Calcula a nova posicao para o eixo X - baseado na largura e impedindo que passe da tela
			if (novoX <= (bolaImageView.frame.size.width / 2)) {
				novoX = bolaImageView.frame.size.width / 2
			}
			if (novoX >= (self.view.frame.size.width - bolaImageView.frame.size.width / 2)) {
				novoX = (self.view.frame.size.width) - (bolaImageView.frame.size.width / 2)
			}
			// Calcula a nova posicao para o eixo Y - baseado na altura e impedindo que passe da tela
			if (novoY <= (bolaImageView.frame.size.height / 2)) {
				novoY = bolaImageView.frame.size.height / 2
			}
			if (novoY >= (self.view.frame.size.height - bolaImageView.frame.size.height / 2)) {
				novoY = (self.view.frame.size.height) - (bolaImageView.frame.size.height / 2)
			}

			// Posiciona a bolinha na tela com os novos valores de x,y
			bolaImageView.center = CGPointMake(novoX, novoY)
		})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
