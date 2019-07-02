/**
 * @File Name          : LeadTriggerHandler.cls
 * @Description        : Trigger Handler for Lead
 * @Author             : makepositive
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    07/01/2019, 2:48:00 PM   makepositive     Initial Version
**/
public with sharing class LeadTriggerHandler extends TriggerHandler
{

  
  public override void beforeInsert() 
  {
    //LeadTriggerHelper.populateCityLookup((List<Lead>) this.newList, (Map<Id, Lead>) this.newMap, false);
    LeadTriggerHelper.populateCityLookupWithSingleton((List<Lead>) this.newList, (Map<Id, Lead>) this.newMap, false);

  }
    
  public override void beforeUpdate() 
  {
      List<Lead> leadsWithChangedCity = new List<Lead>();
      for(Lead newObj : (List<Lead>) newList)
      {
          Lead oldObj = (Lead) oldMap.get(newObj.Id);
          //Populate lookup only if city has changed
          if(newObj.City <> oldObj.City)
          {
              leadsWithChangedCity.add(newObj);
          }
      }
      
      //LeadTriggerHelper.populateCityLookup((List<Lead>) leadsWithChangedCity, (Map<Id, Lead>) this.newMap, true);
      LeadTriggerHelper.populateCityLookupWithSingleton((List<Lead>) leadsWithChangedCity, (Map<Id, Lead>) this.newMap, true);

  }


  // add overrides for other contexts

}