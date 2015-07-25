/**
 * 
 */
package com.apps.insideout.model;

import java.text.SimpleDateFormat;

/**
  * @author Abhimanyu Sharma
 * @version 0.1
 * @since 25/07/2015
 *
 */
public class DestHackPhotographModel {

	
	String photoId, name, hotelId;
	int views;
	long viewTime;
	SimpleDateFormat startTime, endTime;
	
	//TODO have a filter to figure out if the 
	//diff in start time and end time is greater than 5 mins then dont compute rating
	
	public String getPhotoId() {
		return photoId;
	}
	public void setPhotoId(String photoId) {
		this.photoId = photoId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getHotelId() {
		return hotelId;
	}
	public void setHotelId(String hotelId) {
		this.hotelId = hotelId;
	}
	public SimpleDateFormat getStartTime() {
		return startTime;
	}
	public void setStartTime(SimpleDateFormat startTime) {
		this.startTime = startTime;
	}
	public SimpleDateFormat getEndTime() {
		return endTime;
	}
	public void setEndTime(SimpleDateFormat endTime) {
		this.endTime = endTime;
	}
	public long getViewTime() {
		//TODO this is a calculated field and the value should 
		//be fetched from DB and then the diff of nd time and start time should be added
		return viewTime;
	}
	
	public void addToViews(int noOfViews){
		
		views+=noOfViews;
				
	}
	public int getViews(){
		return this.views;
	}
}
