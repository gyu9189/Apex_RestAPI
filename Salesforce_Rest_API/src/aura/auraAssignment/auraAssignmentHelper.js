({
    fetchData : function(component, helper, methodName, params){
        var self = this;
        return new Promise($A.getCallback(function(resolve, reject) {
            let action = component.get('c.' + methodName);            
            action.setParams(params);            
            action.setCallback(helper, function(actionResult) {
                
                console.log(actionResult.getState());
                
                if (actionResult.getState() === 'SUCCESS') {
                    resolve({'c':component, 'h':helper, 'r':actionResult.getReturnValue()});
                } else { 
                    let errors = actionResult.getError();
                    console.log(errors[0]);
                    resolve({'s':actionResult.getState(), 'c':component, 'h':helper, 'r':actionResult.getReturnValue(), 'e':errors[0]});
                }
            });          
            $A.enqueueAction(action);
        }));
    }
})