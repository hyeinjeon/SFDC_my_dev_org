
// back에서는 save에 관한 메소드에서 pdf insert 해주기

public with sharing class PrintStudentListController2 {
    public String recordId { get; set; }
    public List<List<Contact>>  doubleListContact { get; set; }

    public PrintStudentListController2() {
        //url속 파라미터를 가져오는 코드
        recordId = ApexPages.currentPage().GetParameters().get('recordId');
        //Contact 조회쿼리
        List<Contact> listContact = [
                SELECT LastName, Birthdate
                FROM Contact
                WHERE Class__c = :recordId
        ];
        // 리스트를 넣을 리스트
        // 30명씩 Contact를 담는 List
        doubleListContact = new List<List<Contact>>();
        // Contact를 넣을 리스트
        List<Contact> listTmp = new List<Contact>();
        Integer i = 1;
        for(Contact obj : listContact) {
            // Contact를 리스트에 넣어준다
            listTmp.add(obj);
            // APEX에는 ‘%’연산자가 존재하지 않는다.
            // ‘30을 나누면 나머지가 0이다’는 Math.mod(i, 30) == 0 와 같이 표현될 수 있다.
            // Contact이 30의 배수가 되었을때,
            if(Math.mod(i, 30) == 0) {
                // Contact이 들어있는 리스트를 더블리스트에 넣어준다.
                // 즉, 더블리스트에는 Contact이 30개씩 들어간다.
                doubleListContact.add(listTmp);
                // 초기화 : Contact 담는 리스트 초기화
                listTmp = new List<Contact>();
            }
            i++;
        }

        // Contact이 31개, 61개, 91개...가 아닐때,
        // 즉 Contact가 30개일때는 실행이 안됨
        // Contact이 31개 ~ 59개 일때는 30개를 넣고 남은 Contact를 더블리스트에 넣어줌
        if(Math.mod(i, 30) != 1) {
            // 더블리스트에 Contact 리스트를 넣어준다.
            doubleListContact.add(listTmp);
        }
    }
}