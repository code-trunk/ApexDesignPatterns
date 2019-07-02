/**
 * Trigger Handler Framework
 * 
 * Adapted version of https://github.com/kevinohara80/sfdc-trigger-framework
 * 
 * @date    2018-03-09
 * @author  Kevin M. O'Hara & makepositive
 */
public virtual class TriggerHandler {
    
    /**
     * Possible trigger contexts
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    private enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
        AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
        AFTER_UNDELETE
    }
    
    /**
     * Returns a list of the new versions of the sObject records.
     * 
     * This sObject list is only available in insert, update, and 
     * undelete triggers, and the records can only be modified in 
     * before triggers.
     * 
     * Use this variable instead of Trigger.new.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  List<sObject> - New versions of sObject records
     */
    @TestVisible
    protected List<sObject> newList;
    
    /**
     * A map of IDs to the new versions of the sObject records.
     * 
     * This map is only available in before update, after insert, 
     * after update, and after undelete triggers.
     * 
     * Use this variable instead of Trigger.newMap.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Map<Id, sObject> - Map of Ids to new versions
     */
    @TestVisible
    protected Map<Id, sObject> newMap;
    
    /**
     * Returns a list of the old versions of the sObject records.
     * 
     * This sObject list is only available in update and delete 
     * triggers.
     * 
     * Use this variable instead of Trigger.old.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  List<sObject> - Old versions of sObject records
     */
    @TestVisible
    protected List<sObject> oldList;
    
    /**
     * A map of IDs to the old versions of the sObject records.
     * 
     * This map is only available in update and delete triggers.
     * 
     * Use this variable instead of Trigger.oldMap.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Map<Id, sObject> - Map of Ids to old versions
     */
    @TestVisible
    protected Map<Id, sObject> oldMap;
    
    /**
     * Returns true if this trigger was fired before any record 
     * was saved.
     * 
     * Use this variable instead of Trigger.isBefore.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Boolean - Is executing in before context?
     */
    @TestVisible
    protected Boolean isBefore;
    
    /**
     *     Returns true if this trigger was fired after all records 
     * were saved.
     * 
     * Use this variable instead of Trigger.isAfter.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Boolean - Is executing in after context?
     */
    @TestVisible
    protected Boolean isAfter;
    
    /**
     * Returns true if this trigger was fired due to an insert 
     * operation.
     * 
     * Use this variable instead of Trigger.isInsert.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Boolean - Is executing in insert context?
     */
    @TestVisible
    protected Boolean isInsert;
    
    /**
     * Returns true if this trigger was fired due to an update 
     * operation.
     * 
     * Use this variable instead of Trigger.isUpdate.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Boolean - Is executing in update context?
     */
    @TestVisible
    protected Boolean isUpdate;
    
    /**
     * Returns true if this trigger was fired due to a delete 
     * operation.
     * 
     * Use this variable instead of Trigger.isDelete.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Boolean - Is executing in delete context?
     */
    @TestVisible
    protected Boolean isDelete;
    
    /**
     * Returns true if this trigger was fired due to an undelete
     * operation (after a record is recovered from the Recycle Bin).
     * 
     * Use this variable instead of Trigger.isUndelete.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Boolean - Is executing in undelete context?
     */
    @TestVisible
    protected Boolean isUndelete;
    
    /**
     * Returns true if the current context for the Apex code is a 
     * trigger.
     * 
     * Use this variable instead of Trigger.isTriggerExecuting.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Boolean - Is trigger executing?
     */
    protected Boolean isTriggerExecuting;
    
    /**
     * Store the current trigger context - used to dispatch the
     * correct handler method.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  TriggerContext - Trigger execution context
     */
    private TriggerContext context;
    
    /**
     * Get the name of the trigger handler for example if
     * AccountTriggerHandler extends TriggerHandler the
     * handler name is AccountTriggerHandler.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  String - Name of trigger handler
     */
    @TestVisible
    private String handlerName {
        get {
            if (handlerName == null) {
                handlerName = String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
            }
            return handlerName;
        }
        set; 
    }
    
    /**
     * Output variables to debug log before running trigger?
     * 
     * This is helpful for debugging.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Boolean - Output variables to debug log?
     */
    public static Boolean debugVariables = false;
    
    /**
     * Map of handlerName to LoopCount - keep track of how
     * many times run() has been successfully invoked.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Map<String, LoopCount> - Map of handler to
     *          loop count
     */
    private static Map<String, LoopCount> loopCountMap {
        get {
            if (loopCountMap == null) {
                loopCountMap = new Map<String, LoopCount>();
            }
            return loopCountMap;
        }
        set;
    }
    
    /**
     * Set of trigger handlers that have been disabled - 
     * either by custom setting or by calling bypass method.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Set<String> - Set of trigger handlers that
     *          have been disabled
     */
    private static Set<String> bypassedHandlers {
        get {
            if (bypassedHandlers == null) {
                bypassedHandlers = new Set<String>();
                bypassedHandlers.addAll(customSettingBypassedHandlers);
            }
            return bypassedHandlers;
        }
        set;
    }
    
    /**
     * Process deactivation custom setting - hierarchy custom
     * setting so can have different settings for users/profiles.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @return  Process_Deactivation__c - Process deactivation settings
     */
    private static Process_Deactivation__c processDeactivationSetting {
        get {
            if (processDeactivationSetting == null) {
                processDeactivationSetting = Process_Deactivation__c.getInstance();
            }
            return processDeactivationSetting;
        }
        set;
    }
    
    /**
     * Set of trigger handlers that have been disabled by custom
     * setting.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @param   Set<String> - Set of trigger handlers disabled by
     *          Custom Setting
     */
    private static Set<String> customSettingBypassedHandlers {
        get {
            if (customSettingBypassedHandlers == null) {
                customSettingBypassedHandlers = new Set<String>();
                
                if (processDeactivationSetting != null && processDeactivationSetting.Disable_Triggers__c != null) {
                    for (String name : processDeactivationSetting.Disable_Triggers__c.split(',')) {
                        customSettingBypassedHandlers.add(name.trim());
                    }
                }
            }
            return customSettingBypassedHandlers;
        }
        set;
    }
    
    /**
     * Constructor - Initialise member variables from trigger
     * context variables.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    public TriggerHandler() {
        this.setTriggerContextVariables();
    }
    
    /**
     * Main method to call from the trigger to run the handler.
     * 
     * Checks whether to run the handler and dispatches the
     * appropriate handler method.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    public void run() {
        this.setTriggerContext();
        
        if (TriggerHandler.debugVariables) {
            this.debugVariables();
        }
        
        if (!this.validateRun()) {
            return;
        }
        
        this.addToLoopCount();
        
        if (this.context == TriggerContext.BEFORE_INSERT) {
            this.beforeInsert();
        } else if(this.context == TriggerContext.BEFORE_UPDATE) {
            this.beforeUpdate();
        } else if(this.context == TriggerContext.BEFORE_DELETE) {
            this.beforeDelete();
        } else if(this.context == TriggerContext.AFTER_INSERT) {
            this.afterInsert();
        } else if(this.context == TriggerContext.AFTER_UPDATE) {
            this.afterUpdate();
        } else if(this.context == TriggerContext.AFTER_DELETE) {
            this.afterDelete();
        } else if(this.context == TriggerContext.AFTER_UNDELETE) {
            this.afterUndelete();
        }
        
    }
    
    /**
     * Set a maximum number of calls to this trigger handler.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @param   Integer - Maximum number of calls to handler
     */
    public void setMaxLoopCount(Integer max) {
        TriggerHandler.loopCountMap.get(this.handlerName).setMax(max);
    }
    
    /**
     * Remove the limit on calls to this trigger handler.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }
    
      /**
     * Before Insert handler method - override in derived class.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    @TestVisible
    protected virtual void beforeInsert() {}
    
    /**
     * Before Update handler method - override in derived class.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    @TestVisible
    protected virtual void beforeUpdate() {}
    
    /**
     * Before Delete handler method - override in derived class.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    @TestVisible
    protected virtual void beforeDelete() {}
    
    /**
     * After Insert handler method - override in derived class.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    @TestVisible
    protected virtual void afterInsert() {}
    
    /**
     * After Update handler method - override in derived class.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    @TestVisible
    protected virtual void afterUpdate() {}
    
    /**
     * After Delete handler method - override in derived class.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    @TestVisible
    protected virtual void afterDelete() {}
    
    /**
     * After Undelete handler method - override in derived class.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    @TestVisible
    protected virtual void afterUndelete() {}
    
    /**
     * Useful method for dumping variables to debug log.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    protected void debugVariables() {
        system.debug('**************************');
        system.debug('Trigger Handler Variables:');
        system.debug('**************************');
        
        system.debug('handlerName:');
        system.debug(this.handlerName);
        
        system.debug('isTriggerExecuting:');
        system.debug(this.isTriggerExecuting);
        
        system.debug('context:');
        system.debug(this.context);
        
        system.debug('newList:');
        system.debug(this.newList);
        system.debug('newMap:');
        system.debug(this.newMap);
        
        system.debug('oldList:');
        system.debug(this.oldList);
        system.debug('oldMap:');
        system.debug(this.oldMap);
        
        system.debug('isBefore:');
        system.debug(this.isBefore);
        system.debug('isAfter:');
        system.debug(this.isAfter);
        
        system.debug('isInsert:');
        system.debug(this.isInsert);
        system.debug('isUpdate:');
        system.debug(this.isUpdate);
        system.debug('isDelete:');
        system.debug(this.isDelete);
        system.debug('isUndelete:');
        system.debug(this.isUndelete);
        
        system.debug('processDeactivationSetting:');
        system.debug(TriggerHandler.processDeactivationSetting);
        
        system.debug('customSettingBypassedHandlers:');
        system.debug(TriggerHandler.customSettingBypassedHandlers);
        system.debug('bypassedHandlers:');
        system.debug(TriggerHandler.bypassedHandlers);
        
        system.debug('loopCountMap:');
        system.debug(TriggerHandler.loopCountMap);
    }
    
    /**
     * Disable a selected trigger handler.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @param   String - Handler to disable
     */
    public static void bypass(String handlerName) {
        TriggerHandler.bypassedHandlers.add(handlerName);
    }
    
    /**
     * Re-enable a selected trigger handler.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @param   String - Handler to enable
     */
    public static void clearBypass(String handlerName) {
        TriggerHandler.bypassedHandlers.remove(handlerName);
    }
    
    /**
     * Check if selected trigger handler is disabled?
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     * @param   String - Handler to check
     * @return  Boolean - Is trigger handler disabled?
     */
    public static Boolean isBypassed(String handlerName) {
        return TriggerHandler.bypassedHandlers.contains(handlerName);
    }
    
    /**
     * Re-enable all trigger handlers.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    public static void clearAllBypasses() {
        TriggerHandler.bypassedHandlers.clear();
    }
    
    /**
     * Initialise variables from trigger context variables.
     * 
     * If not executing in context of a trigger (e.g. a test class)
     * variables will need to be set before calling run().
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    private void setTriggerContextVariables() {
        this.isTriggerExecuting = Trigger.isExecuting;
        
        if (this.isTriggerExecuting) {
            this.newList = Trigger.new;
            this.newMap = Trigger.newMap;
            this.oldList = Trigger.old;
            this.oldMap = Trigger.oldMap;
        
            this.isBefore = Trigger.isBefore;
            this.isAfter = Trigger.isAfter;
            this.isInsert = Trigger.isInsert;
            this.isUpdate = Trigger.isUpdate;
            this.isDelete = Trigger.isDelete;
            this.isUndelete = Trigger.isUndelete;
        } else {
            this.newList = new List<sObject>();
            this.newMap = new Map<Id, sObject>();
            this.oldList = new List<sObject>();
            this.oldMap = new Map<Id, sObject>();
            
            this.isBefore = false;
            this.isAfter = false;
            this.isInsert = false;
            this.isUpdate = false;
            this.isDelete = false;
            this.isUndelete = false;
        }
        
        if (!TriggerHandler.loopCountMap.containsKey(this.handlerName)) {
            TriggerHandler.loopCountMap.put(this.handlerName, new LoopCount(-1));
        }
    }
    
    /**
     * Determine trigger context that will be used to dispatch the
     * appropriate handler method.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    private void setTriggerContext() {
        if (isBefore && isInsert) {
            this.context = TriggerContext.BEFORE_INSERT;
        } else if (isBefore && isUpdate) {
            this.context = TriggerContext.BEFORE_UPDATE;
        } else if (isBefore && isDelete) {
            this.context = TriggerContext.BEFORE_DELETE;
        } else if (isAfter && isInsert) {
            this.context = TriggerContext.AFTER_INSERT;
        } else if (isAfter && isUpdate) {
            this.context = TriggerContext.AFTER_UPDATE;
        } else if (isAfter && isDelete) {
            this.context = TriggerContext.AFTER_DELETE;
        } else if (isAfter && isUndelete) {
            this.context = TriggerContext.AFTER_UNDELETE;
        }
    }
    
    /**
     * Increment loop counter for trigger handler and check
     * limit has not been exceeded.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    private void addToLoopCount() {
        if (TriggerHandler.loopCountMap.containsKey(this.handlerName)) {
            Boolean exceeded = TriggerHandler.loopCountMap.get(this.handlerName).increment();
            if (exceeded) {
                Integer max = TriggerHandler.loopCountMap.get(this.handlerName).max;
                throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + this.handlerName);
            }
        }
    }
    
    /**
     * Check if trigger handler should run - check there is a context
     * and that the trigger handler has not been disabled.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    private Boolean validateRun() {
        if (this.context == null) {
            throw new TriggerHandlerException('Failed to determine trigger context!');
        }
        
        if (TriggerHandler.processDeactivationSetting.Disable_All_Triggers__c
            || TriggerHandler.isBypassed(handlerName)) {
            system.debug(this.handlerName + ' disabled!');
            return false;
        }
        return true;
    }
    
    /**
     * Inner class for managing the loop count per handler.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    private class LoopCount {
        
        /**
         * Maximum number of allowed trigger iterations.
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara & makepositive
         * @return  Integer - Maximum number of trigger iterations
         */
        private Integer max;
        
        /**
         * Current number of trigger iterations.
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara & makepositive
         * @return  Integer - Current number of trigger iterations
         */
        private Integer count;
        
        /**
         * Construct with specified maximum number of iterations.
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara & makepositive
         * @param   Integer - Maximum number of trigger iterations
         */
        public LoopCount(Integer max) {
            this.max = max;
            this.count = 0;
        }
        
        /**
         * Increment number of iterations and return whether or not
         * the limit has been reached.
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara & makepositive
         * @return  Boolean - Limit has been reached?
         */
        public Boolean increment() {
            this.count++;
            return this.exceeded();
        }
        
        /**
         * Has limit of iterations been reached?
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara & makepositive
         * @return  Boolean - Limit has been reached?
         */
        public Boolean exceeded() {
            if(this.max < 0) {
                return false;
            }
            
            if(this.count > this.max) {
                return true;
            }
            return false;
        }
        
        /**
         * Set maximum number of iterations
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara & makepositive
         * @param   Integer - Maximum number of iterations
         */
        public void setMax(Integer max) {
            this.max = max;
        }
    }
    
    /**
     * General Trigger Handler Exception.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara & makepositive
     */
    public class TriggerHandlerException extends Exception {}
}