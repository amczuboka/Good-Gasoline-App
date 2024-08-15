import UIKit
import GooglePlaces

class CustomMarkerView: UIView {
    private let stackView: UIStackView
    private let nameLabel: UILabel
    private let addressLabel: UILabel
    private let phoneNumberLabel: UILabel
    private let openingHoursLabel: UILabel
    private let websiteLabel: UILabel
    private let ratingValueLabel: UILabel
    private let priceLevelLabel: UILabel
    private let priceLevelValueLabel: UILabel
    private let userRatingsTotalLabel: UILabel
    private let businessStatusLabel: UILabel
    private let businessStatusValueLabel: UILabel

    init(place: GMSPlace) {
        nameLabel = UILabel()
        addressLabel = UILabel()
        phoneNumberLabel = UILabel()
        openingHoursLabel = UILabel()
        websiteLabel = UILabel()
        ratingValueLabel = UILabel()
        priceLevelLabel = UILabel()
        priceLevelValueLabel = UILabel()
        userRatingsTotalLabel = UILabel()
        businessStatusLabel = UILabel()
        businessStatusValueLabel = UILabel()
        
        stackView = UIStackView()

        super.init(frame: .zero)
        
        setupView(place: place)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    private func setupView(place: GMSPlace) {
        backgroundColor = UIColor.white.withAlphaComponent(0.9)
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = place.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1

        addressLabel.text = place.formattedAddress
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        addressLabel.textColor = UIColor.systemBlue
        addressLabel.numberOfLines = 0
        
        phoneNumberLabel.text = "Phone: \(place.phoneNumber ?? "N/A")"
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 14)
        phoneNumberLabel.textColor = UIColor.darkGray
        
        if let openingHours = place.openingHours {
            openingHoursLabel.text = formatOpeningHours(openingHours)
        } else {
            openingHoursLabel.text = "Opening Hours: N/A"
        }
        openingHoursLabel.font = UIFont.systemFont(ofSize: 14)
        openingHoursLabel.textColor = UIColor.darkGray
        openingHoursLabel.numberOfLines = 0
        
        if let website = place.website {
            websiteLabel.text = "\(website)"
            websiteLabel.textColor = UIColor.systemBlue
        }
        
        ratingValueLabel.text = "\(place.rating)"
        ratingValueLabel.font = UIFont.systemFont(ofSize: 14)
        ratingValueLabel.textColor = UIColor.darkGray
        ratingValueLabel.textAlignment = .center
        
        userRatingsTotalLabel.text = "\(place.userRatingsTotal) ratings"
        userRatingsTotalLabel.font = UIFont.systemFont(ofSize: 14)
        userRatingsTotalLabel.textColor = UIColor.darkGray
        userRatingsTotalLabel.textAlignment = .center
        
        businessStatusLabel.text = "Status"
        businessStatusLabel.font = UIFont.systemFont(ofSize: 14)
        businessStatusLabel.textColor = UIColor.darkGray
        businessStatusLabel.textAlignment = .center
        
        businessStatusValueLabel.text = {
            switch place.businessStatus {
            case .operational: return "Open"
            case .closedTemporarily: return "Closed Temporarily"
            case .closedPermanently: return "Closed Permanently"
            default: return "Unknown"
            }
        }()
        businessStatusValueLabel.font = UIFont.systemFont(ofSize: 14)
        businessStatusValueLabel.textColor = UIColor.darkGray
        businessStatusValueLabel.textAlignment = .center
        
        priceLevelLabel.text = "Price Level"
        priceLevelLabel.font = UIFont.systemFont(ofSize: 14)
        priceLevelLabel.textColor = UIColor.darkGray
        priceLevelLabel.textAlignment = .center
        
        priceLevelValueLabel.text = {
            switch place.priceLevel {
            case .free: return "Free"
            case .cheap: return "Cheap"
            case .medium: return "Medium"
            case .high: return "High"
            case .expensive: return "Expensive"
            default: return "N/A"
            }
        }()
        priceLevelValueLabel.font = UIFont.systemFont(ofSize: 14)
        priceLevelValueLabel.textColor = UIColor.darkGray
        priceLevelValueLabel.textAlignment = .center
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(createGridSection())
        stackView.addArrangedSubview(websiteLabel)
        stackView.addArrangedSubview(phoneNumberLabel)
        stackView.addArrangedSubview(openingHoursLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func createGridSection() -> UIStackView {
        let gridStackView = UIStackView(arrangedSubviews: [
            createVerticalStack(for: businessStatusLabel, valueLabel: businessStatusValueLabel),
            createVerticalStack(for: userRatingsTotalLabel, valueLabel: ratingValueLabel),
            createVerticalStack(for: priceLevelLabel, valueLabel: priceLevelValueLabel)
        ])
        gridStackView.axis = .horizontal
        gridStackView.distribution = .fillEqually
        gridStackView.spacing = 10
        return gridStackView
    }
    
    private func createVerticalStack(for titleLabel: UILabel, valueLabel: UILabel) -> UIStackView {
        let verticalStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.spacing = 2
        return verticalStack
    }
    
    private func formatOpeningHours(_ openingHours: GMSOpeningHours) -> String {
        var formattedHours = "Opening Hours:\n"
        if let weekdayText = openingHours.weekdayText {
            formattedHours += weekdayText.joined(separator: "\n")
        } else {
            formattedHours += "N/A"
        }
        return formattedHours
    }
}
