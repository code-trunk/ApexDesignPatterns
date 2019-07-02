/**
 * @File Name          : ErrorMasterUtil.cls
 * @Description        : The Singleton Class - Eager Initialization variant for managing error messages
 * @Author             : makepositive
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    07/01/2019, 2:18:19 PM   makepositive     Initial Version
**/
public with sharing class ErrorMasterUtil {
    
    // a static, final variable that initializes an instance of the class
    // as it's final, it will only be initialized once
    private static final ErrorMasterUtil instance = new ErrorMasterUtil();
    
    //the map of error codes
    public Map<String,String> errorCodeWithMessageMap {get;private set;}
    
    // The constructor is private and initializes the errorCodeWithMessageMap
    private ErrorMasterUtil()
    {
        System.Debug('Initializing Map');
        errorCodeWithMessageMap = new Map<String, String>();
        List<Error_Code__mdt> errorList = new List<Error_Code__mdt>(  [SELECT  ID,
                                                                               Code__c,
                                                                               Message__c 
                                                                        FROM Error_Code__mdt]);
           for(Error_Code__mdt errorObj : errorList)
           {
               //Error Code as the Key and Error Message as the value
               errorCodeWithMessageMap.put(errorObj.Code__c, errorObj.Message__c);
           }

    }
    
    /* getInstance : 
     * The instance of the class is instantiated as 
     * a final, static variable, 
     * which means that only one instance ever exists. 
     * This method is typically used if the cost of creating 
     * the instance is small.
     */
    public static ErrorMasterUtil getInstance(){
        // eager load of the class
        return instance;
    }

}