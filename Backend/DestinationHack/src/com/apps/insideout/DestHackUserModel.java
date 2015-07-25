/**
 * 
 */
package com.apps.insideout;

/**
 * @author Abhimanyu Sharma
 * @version 0.1
 * @since 25/07/2015
 *
 */
public class DestHackUserModel {

	private String name = null;
	private String fbId = null;
	private String currentLoc= null; //This can remain null as well
	private String uId = null;
	
	public DestHackUserModel(String name, String fbId, String currentLoc) {
	
		this.setName(name);
		this.setFbId(fbId);
		this.setCurrentLoc(currentLoc);
		
	}
	
	public String getName() {
		return name;
	}
	public String getFbId() {
		return fbId;
	}
	public String getCurrentLoc() {
		return currentLoc;
	}
	private void setName(String name) {
		this.name = name;
	}
	private void setFbId(String fbId) {
		this.fbId = fbId;
	}
	private void setCurrentLoc(String currentLoc) {
		this.currentLoc = currentLoc;
	}
	
	public String getUId() {
		//TODO need per basis implementation
		//should be fetched from DB when required
		//if not found the create a new DB entry
		
		return uId;
	}

}
