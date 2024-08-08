import UIKit
import GooglePlaces

class CustomMarkerView: UIView {
    private let stackView: UIStackView
    private let nameLabel: UILabel
    private let addressLabel: UILabel
    private let phoneNumberLabel: UILabel
    private let directionsLabel: UIButton
    private let openingHoursLabel: UILabel
    private let addressStackView: UIStackView

    init(place: GMSPlace) {
        nameLabel = UILabel()
        addressLabel = UILabel()
        phoneNumberLabel = UILabel()
        directionsLabel = UIButton()
        openingHoursLabel = UILabel()

        addressStackView = UIStackView(arrangedSubviews: [addressLabel, directionsLabel])
        stackView = UIStackView(arrangedSubviews: [nameLabel, addressStackView, openingHoursLabel, phoneNumberLabel])
        
        super.init(frame: .zero)
        
        setupView(place: place)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(place: GMSPlace) {
        print(place)
        backgroundColor = UIColor.systemPink.withAlphaComponent(0.6)
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addressStackView.axis = .horizontal
        addressStackView.spacing = 8
        addressStackView.alignment = .leading
        addressStackView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "\(place.name ?? "Unnamed Gas Station")"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = UIColor.black
        
        addressLabel.text = "\(place.formattedAddress ?? "Unknown address")"
        addressLabel.textColor = UIColor.systemBlue
        
        directionsLabel.setTitle("Get Directions", for: .normal)
        directionsLabel.setTitleColor(.white, for: .normal)
        directionsLabel.backgroundColor = .blue
        directionsLabel.layer.cornerRadius = 4
        
        phoneNumberLabel.text = "Phone: \(place.phoneNumber ?? "N/A")"
        
        if let openingHours = place.openingHours {
            openingHoursLabel.text = "Opening Hours: \(openingHours) \(place.rating)"
        } else {
            openingHoursLabel.text = "Opening Hours: N/A"
        }
        openingHoursLabel.textColor = UIColor.black
                
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
        
        addressLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        addressLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        directionsLabel.setContentHuggingPriority(.required, for: .horizontal)
        directionsLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
