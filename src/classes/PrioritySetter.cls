/**
 * @File Name          : PrioritySetter.cls
 * @Description        : Context setter for Strategy Design Pattern
 *                     : - Helps select the priority setting algorithm for for a specific client
 * @Author             : makepositive
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    07/01/2019, 2:48:00 PM   makepositive     Initial Version
**/
public without sharing class PrioritySetter {
    public class NameException extends Exception{} 

    public static final Map<String,PriorityStrategy> strategies;

    static{
        // Retrieve comma delimited list of strategies from a Custom Setting
        Priority_Strategy__c gv = Priority_Strategy__c.getInstance();

        // Populate a List Collection of strategy names e.g., ManagedServices, Services etc
        List<String> strategyNames = new List<String>();
        if(gv != null && gv.List_of_Strategies__c  != null) strategyNames = gv.List_of_Strategies__c.split(',');

        // Populate a map of strategy names to concrete implementations
        // using Type.forName for each strategy string
        strategies = new Map<String,PriorityStrategy>();
        for(String name : strategyNames){
            try{strategies.put(name, (PriorityStrategy)Type.forName(name + 'Impl').newInstance());}
            catch(Exception e){continue;} //skip bad name silently
        }
    }

    private PriorityStrategy strategy;

    public PrioritySetter(String name){
        if(!strategies.containsKey(name)) throw new NameException(name);
        strategy = strategies.get(name);
    }

    public void setPriority(List<Case> caseList){
        strategy.setPriority(caseList);
    }
}