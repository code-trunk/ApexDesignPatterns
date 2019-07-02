/**
 * @File Name          : AccountTriggerHandler.cls
 * @Description        : Trigger Handler for Account
 * @Author             : makepositive
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    07/01/2019, 2:48:00 PM   makepositive     Initial Version
**/
public with sharing class AccountTriggerHandler extends TriggerHandler
{

  
  public override void beforeInsert() 
  {
    //AccountTriggerHelper.populateCityLookup((List<Account>) this.newList, (Map<Id, Account>) this.newMap, false);
    AccountTriggerHelper.populateCityLookupWithSingleton((List<Account>) this.newList, (Map<Id, Account>) this.newMap, false);
  }
    
  public override void beforeUpdate() 
  {
      List<Account> leadsWithChangedCity = new List<Account>();
      for(Account newObj : (List<Account>) newList)
      {
          Account oldObj = (Account) oldMap.get(newObj.Id);
          //Populate lookup only if city has changed
          if(newObj.ShippingCity  <> oldObj.ShippingCity )
          {
              leadsWithChangedCity.add(newObj);
          }
      }
      
      //AccountTriggerHelper.populateCityLookup((List<Account>) leadsWithChangedCity, (Map<Id, Account>) this.newMap, true);
      AccountTriggerHelper.populateCityLookupWithSingleton((List<Account>) leadsWithChangedCity, (Map<Id, Account>) this.newMap, true);
  }


  // add overrides for other contexts

}