/**
 * @File Name          : AccountTrigger.trigger
 * @Description        : Trigger for Account
 * @Author             : makepositive
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    07/01/2019, 2:18:19 PM   makepositive     Initial Version
**/
trigger AccountTrigger on Account (before insert, before update) {
     new AccountTriggerHandler().run();
}