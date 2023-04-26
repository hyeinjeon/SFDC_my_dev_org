public class AsyncExecutionExample implements Queueable {
        public void execute(QueueableContext context) {
                Account a = new Account(Name='Acme', Phone='(415) 555-1212');
                insert a;
        }
}

ID jobID = System.enqueueJob(new AsyncExecutionExample());
AsyncApexJob jobInfo = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id =: jobID];

public class AsyncExecutionExample implements Queueable {
        public void execute(QueueableContext context) {
                // Your processing logic here

                // Chain this job to next job by submitting the next job
                System.enqueueJob(new SecondJob());
        }
}