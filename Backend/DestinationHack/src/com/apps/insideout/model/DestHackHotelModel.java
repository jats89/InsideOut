/**
 * 
 */
package com.apps.insideout.model;

/**
 * @author Abhimanyu Sharma
 * @version 0.1
 * @since 25/07/2015
 *
 */
public class DestHackHotelModel {

	
	String hId, name, loc, priceRange; 
	Double overAllRating, foodRating, ambience, cleanliness, service;
	public String gethId() {
		return hId;
	}
	public void sethId(String hId) {
		this.hId = hId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getLoc() {
		return loc;
	}
	public void setLoc(String loc) {
		this.loc = loc;
	}
	public String getPriceRange() {
		return priceRange;
	}
	public void setPriceRange(String priceRange) {
		this.priceRange = priceRange;
	}
	public Double getFoodRating() {
		return foodRating;
	}
	public void setFoodRating(Double foodRating) {
		this.foodRating = foodRating;
	}
	public Double getAmbience() {
		return ambience;
	}
	public void setAmbience(Double ambience) {
		this.ambience = ambience;
	}
	public Double getCleanliness() {
		return cleanliness;
	}
	public void setCleanliness(Double cleanliness) {
		this.cleanliness = cleanliness;
	}
	public Double getService() {
		return service;
	}
	public void setService(Double service) {
		this.service = service;
	}
	public Double getOverAllRating() {
		return overAllRating;
	}
	
	
	
	
	
	
}
