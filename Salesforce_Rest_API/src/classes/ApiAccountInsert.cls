/**
 * Created by 전일규 on 2024-01-04.
 */

public class ApiAccountInsert implements Rest_ApiDoProcess {

    public Rest_ApiResponseProcessing doProcess(Rest_ApiRequestProcessing request, Rest_ApiResponseProcessing response) {
        System.debug('ApiAccountInsert Class -> doProcess method :::');
        System.debug('request :::  ' + request);
        Savepoint savepoint = Database.setSavepoint();
        try {
            Map<String, Object> data = request.requestData;
            System.debug('data :::  ' + data);
            Account acc = new Account();
            acc.Name = (String) data.get('accountName');
            acc.Phone = (String) data.get('accountNumber');

            Database.insert(acc);
            if(string.isNotBlank(acc.Id)) {
                response = new Rest_ApiResponseProcessing();
                response.response = (Object)acc;
            }

        }catch(Exception e) {
            System.debug('ApiAccountInsert ::: ' + e.getTypeName());
            System.debug('Message :' + e.getMessage() + '\n line : ' + e.getLineNumber());
            Database.rollback(savepoint);
        }finally {
            // Logging work to be added
        }
        return response;
    }
}