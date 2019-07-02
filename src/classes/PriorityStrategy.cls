/**
 * @File Name          : PriorityStrategy.cls
 * @Description        : Interface for Strategy Design Pattern
 *                     : - Helps execute the priority setting algorithm for a specific client
 * @Author             : makepositive
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    07/01/2019, 2:48:00 PM   makepositive     Initial Version
**/
public interface PriorityStrategy 
{

    // Use this method to execute the priority setting algorithm for a specific client.
    // The client should not be impacted if any implementation under this strategy is modified
    // OR a new strategy is added
    void setPriority(List<Case> caseList);

}