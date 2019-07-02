/**
 * @File Name          : LeadTrigger.trigger
 * @Description        : Trigger for Lead
 * @Author             : makepositive
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    07/01/2019, 2:18:19 PM   makepositive     Initial Version
**/
trigger LeadTrigger on Lead (before insert, before update) {
     new LeadTriggerHandler().run();
}