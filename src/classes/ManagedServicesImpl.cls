/**
 * @File Name          : ManagedServicesImpl.cls
 * @Description        : Service Implementation for Strategy Design Pattern
 *                     : - Helps execute the priority setting algorithm for Managed Services
 * @Author             : makepositive
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    07/01/2019, 2:48:00 PM   makepositive     Initial Version
**/
public without sharing class ManagedServicesImpl implements PriorityStrategy
{
        public void setPriority(List<Case> caseList)
        {
            System.Debug('ManagedServices Priority Execution');
            
            //Step 1 : Query data for deciding factors
            executeQuery(caseList);
            
            //Step 2 : execute custom logic to calculate priority
            caseList = executePriorityAlgorithm(caseList);
            
            //Step 3 : Stamp Priority for today on the cases
            stampPriority(caseList);
        }
    
        /*
         * Description : Used to query details from other objects where deciding factors lie
         */
        private void executeQuery(List<Case> caseList)
        {
            //Query various details from several Objects
            //Set class variables with the resultant values
        }
    
        /*
         * Description : Used to calculate priority as per the defined custom logic
         * @return List<Case> : List of Cases priortized as per the algorithm.
         */
        private List<Case> executePriorityAlgorithm(List<Case> caseList)
        {
            //The custom logic implemented here to calculate priority for each case.
            return new List<Case>();
        }
    
    
        /*
         * Description : Used to calculate priority as per the defined custom logic
         * @return List<Case> : List of Cases priortized as per the algorithm.
         */
        private List<Case> stampPriority(List<Case> priortizedCases)
        {
            // The custom logic implemented here to update cases with priority
            // and handle any partial errors
            
            return new List<Case>();
        }


}