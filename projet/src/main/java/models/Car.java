package models;

public class Car {
    private int id;
    private String carName;
    private String carDescription;
    private double pricePerDay;
    private String carType;
    private String imageUrl;
    private String fuelType;
    private int seats;
    private String transmission;
    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCarName() {
        return carName;
    }

    public void setCarName(String carName) {
        this.carName = carName;
    }

    public String getCarDescription() {
        return carDescription;
    }

    public void setCarDescription(String carDescription) {
        this.carDescription = carDescription;
    }

    public double getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(double pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public String getCarType() {
        return carType;
    }

    public void setCarType(String carType) {
        this.carType = carType;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

	public void setAvailability(boolean boolean1) {
		// TODO Auto-generated method stub
		
	}
	public String getFuelType() {
	    return fuelType;
	}

	public void setFuelType(String fuelType) {
	    this.fuelType = fuelType;
	}

	public int getSeats() {
	    return seats;
	}

	public void setSeats(int seats) {
	    this.seats = seats;
	}

	public String getTransmission() {
	    return transmission;
	}

	public void setTransmission(String transmission) {
	    this.transmission = transmission;
	}
}
