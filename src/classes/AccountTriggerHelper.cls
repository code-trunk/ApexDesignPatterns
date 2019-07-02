/**
 * @File Name          : AccountTriggerHelper.cls
 * @Description        : Trigger Helper for Account
 * @Author             : makepositive
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    07/01/2019, 2:48:00 PM   makepositive     Initial Version
**/
public with sharing class AccountTriggerHelper {
    
    /**
    * Purpose : Populates the City Lookup on Account from City Master; returns error otherwise
    * @param List<Account>
    * @return void
    * */
    public static void populateCityLookup(List<Account> newList, Map<Id, Account> newMap, Boolean isUpdate)
    {
       Set<String> cityCodeSet = new Set<String>();
       for(Account newObj : newList)
       {
          if( String.isNotBlank(newObj.ShippingCity ) )
          {
              cityCodeSet.add(newObj.ShippingCity.toLowerCase());
          }
       }
       if(!cityCodeSet.isEmpty())
       {
           //Fetch the list of cities available in the city master
           Map<String, City__c> cityMap = getCityMaster( cityCodeSet );
           
           //Fetch the error message for invalid city code
           String errorMessage = getErrorMessage( AllConstants.CITY_NOT_FOUND_ERROR );
           
           for(Account newObj : newList)
           {
              if( String.isNotBlank(newObj.ShippingCity ) )
              {
                  if( cityMap.containsKey(newObj.ShippingCity.toLowerCase()) )
                      newObj.City__c = cityMap.get(newObj.ShippingCity.toLowerCase()).Id;
                  else
                  {
                      if(isUpdate == TRUE)
                        newMap.get(newObj.Id).addError(errorMessage);
                      else
                        newObj.addError(errorMessage);

                  }
              }

           }

       }
        
       
        
    }
    
    /**
    * Purpose : Queries the City Object from database for specified City Codes
    * @param Set<String> - City Codes to be queried
    * @return Map<String, City__c> - City record as the value against the city code as the key
    * */
    private static Map<String, City__c> getCityMaster(Set<String> cityCodeSet)
    {
       Map<String, City__c> cityCodeWithCityRecordMap = new Map<String, City__c>();
       if( !cityCodeSet.isEmpty() )
       {
           List<City__c> cityList = new List<City__c>([SELECT ID,
                                                              Name,
                                                              Code__c,
                                                              State__c 
                                                       FROM City__c
                                                       WHERE Code__c IN :cityCodeSet]);
           for(City__c cityObj : cityList)
           {
               cityCodeWithCityRecordMap.put(cityObj.Code__c.toLowerCase(), cityObj);
           }
       }
       return cityCodeWithCityRecordMap;
    }
    
    /**
    * Purpose : Queries the Error Code from Custom Setting
    * @param String - Error Codes to be queried
    * @return String - Error message as found at the metadata record.
    * */
    private static String getErrorMessage(String errorCode)
    {
       String errorMessage;
       if( String.isNotBlank( errorCode ) )
       {
           List<Error_Code__mdt> errorList = new List<Error_Code__mdt>([SELECT ID,
                                                                               Code__c,
                                                                               Message__c 
                                                                        FROM Error_Code__mdt 
                                                                        WHERE Code__c LIKE :errorCode ]);
           for(Error_Code__mdt errorObj : errorList)
           {
               errorMessage = errorObj.Message__c;
           }
       }
       return errorMessage;
    }

    /**
    * Purpose : Populates the City Lookup on Account from City Master; returns error otherwise
    * @param List<Account>
    * @return void
    * */
    public static void populateCityLookupWithSingleton(List<Account> newList, Map<Id, Account> newMap, Boolean isUpdate)
    {
            CityMasterUtil cmuObj = CityMasterUtil.getInstance();
            ErrorMasterUtil emuObj = ErrorMasterUtil.getInstance();

        
           //Fetch the list of cities available in the city master
           Map<String, City__c> cityMap = cmuObj.cityCodeWithCityRecordMap;
           
           //Fetch the error message for invalid city code
           String errorMessage = '';
           if( emuObj.errorCodeWithMessageMap.containsKey(AllConstants.CITY_NOT_FOUND_ERROR) )
               errorMessage = emuObj.errorCodeWithMessageMap.get(AllConstants.CITY_NOT_FOUND_ERROR);
           
           for(Account newObj : newList)
           {
              if( String.isNotBlank(newObj.ShippingCity ) )
              {
                  if( cityMap.containsKey(newObj.ShippingCity.toLowerCase()) )
                      newObj.City__c = cityMap.get(newObj.ShippingCity.toLowerCase()).Id;
                  else
                  {
                      if(isUpdate == TRUE)
                        newMap.get(newObj.Id).addError(errorMessage);
                      else
                        newObj.addError(errorMessage);

                  }
              }

           }
    }



}