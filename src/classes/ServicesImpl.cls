/**
 * @File Name          : ServicesImpl.cls
 * @Description        : Service Implementation for Strategy Design Pattern
 *                     : - Helps execute the priority setting algorithm for Services
 * @Author             : makepositive
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    07/01/2019, 2:48:00 PM   makepositive     Initial Version
**/
public without sharing class ServicesImpl implements PriorityStrategy 
{
        public void setPriority(List<Case> caseList)
        {
            System.Debug('Services Priority Execution');

            //Step 1 : get all data required from related objects such as account, project stage, project status etc.
            List<Account> accountList = getAccounts(caseList);
            
            //Step 2 : sort cases by Importance, Estimated time etc.
            caseList = sortCases(caseList);
            
            //Step 3 : execute custom logic to calculate priority
            caseList = calculatePriority(caseList, accountList);

            //Step 4 : Stamp Priority for today on the cases
            List<Case> finalCaseList = stampPriority(caseList);
            
            //Step 5 : Send Email with excel of priortized cases attached to the Team Email alias.
            sendNotification(finalCaseList);
        }
        
        /*
         * Description : Used to query details from the Account and other related objects
         * @return List<Account> : List of Accounts with all fields required for Priority calculation. 
         */
        private List<Account> getAccounts(List<Case> caseList)
        {
            return new List<Account>();
        }
    
        /*
         * Description : Used to sort the cases in the input list as per the defined custom logic
         * @return List<Case> : List of Cases sorted as per the algorithm.
         */
        private List<Case> sortCases(List<Case> caseList)
        {
            return new List<Case>();
        }
    
        /*
         * Description : Used to calculate priority as per the defined custom logic
         * @return List<Case> : List of Cases priortized as per the algorithm.
         */
        private List<Case> calculatePriority(List<Case> sortedCaseList, List<Account> accountList)
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
            List<Case> errorCaseList = new List<Case>();
            
            // and handle any partial errors
            reportErrors(errorCaseList);
            
            return new List<Case>();
        }
    
    

        /*
         * Description : Used to report errors on cases where priority couldn't be stamped
         * Action : Sends error report to the Apex exception email list.
         */
        private void reportErrors(List<Case> errorCaseList)
        {
            // The custom logic implemented here to send email in a specified format 
        }
    
    
        /*
         * Description : Send notification to team email alias
         */
        private void sendNotification(List<Case> caseList)
        {
            // The custom logic implemented here to send email
            // As an excel with Project Specific Sheets
        }



}