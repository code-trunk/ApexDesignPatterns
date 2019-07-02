/**
 * @File Name          : CityMasterUtil.cls
 * @Description        : Singleton Implementation for managing City Codes Map
 *                     : lazy-initialization variant
 * @Author             : makepositive
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    07/01/2019, 2:18:19 PM   makepositive     Initial Version
**/
public with sharing class CityMasterUtil {
    
    // private static variable referencing the class
    private static CityMasterUtil instance = null;
    
    // the map of city master
    public Map<String, City__c>  cityCodeWithCityRecordMap {get;private set;} 

    // The constructor is private and initializes the cityCodeWithCityRecordMap
    private CityMasterUtil()
    {
           System.Debug('Initializing Map');
           cityCodeWithCityRecordMap = new Map<String, City__c>();
           List<City__c> cityList = new List<City__c>([SELECT ID,
                                                              Name,
                                                              Code__c,
                                                              State__c 
                                                       FROM City__c]);
           for(City__c cityObj : cityList)
           {
               cityCodeWithCityRecordMap.put(cityObj.Code__c.toLowerCase(), cityObj);
           }
        

    }

    
    /* getInstance : a static method that returns the instance of the CityMasterUtil
     * The getInstance() static method will only instantiate an instance of the class 
     * if it doesn't already exist in 
     * a lazy-initialization manner
     */
    public static CityMasterUtil getInstance(){
        // lazy load the cityCodeWithCityRecordMap - only initialize if it doesn't already exist
        if(instance == null) 
        {
            instance = new CityMasterUtil();
        }
        
        return instance;
    }


}