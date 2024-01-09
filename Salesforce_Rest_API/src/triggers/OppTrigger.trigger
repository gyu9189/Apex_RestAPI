trigger OppTrigger on Opportunity (before update) {

    System.debug('Trigger.new :::  ' + Trigger.new);
    for(Opportunity opp : Trigger.new) {
        if(opp.StageName != Trigger.old[0].StageName) {
            System.debug('Trigger.old[0].StageName ::: ' + Trigger.old[0].StageName);
            if(opp.StageName == 'Closed Won') {
                opp.Name = opp.Name.split(' - *')[0] + ' - *수주 성공(' + system.today().format() + ')';
            } else if(opp.StageName == 'Closed Lost') {
                opp.Name = opp.Name.split(' - *')[0] + ' - *수주 실패(' + system.today().format() + ')';
            } else {
                opp.Name = opp.Name.split(' - *')[0];
            }
        }
    }
}