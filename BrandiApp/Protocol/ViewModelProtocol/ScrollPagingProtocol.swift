
import Foundation

//프로토콜 자체에서 데이터 변환이 일어나기때문에
//Class 에서만 사용이가능하도록 AnyObject 채택
protocol ScrollPagingProtocl : AnyObject {
    
    
    
    var totalCount : Int { get set}
    
    var itemCount : Int { get }
  
    //페이징카운트
    var pagingCount : Int  { get set }
  
   
    func pagingCountClear()
    
    func pagingCountSetting(totalCount : Int)
    
    func pagingAbleChecking(paingAble : PagingAbleModel , totalCount : Int) -> Bool
}






extension ScrollPagingProtocl {
    

    
    func pagingCountClear(){
        self.totalCount = 0
        self.pagingCount  = 1
    }
    //요청하는 아이템의 갯수는 30개
    //최초시작
    //ex 0개 1페이지 30개 요청
    //ex 30개 1페이지 30개
    //점검
    //
    func pagingCountSetting(totalCount : Int)  {
        self.totalCount = totalCount
  
        if(!(totalCount < itemCount * pagingCount)){
            self.pagingCount += 1
        }
    }
    //이렇게 복잡하게 컨트롤 하지않고 다음 검색에서 주는 is_end , pagingCount 두개만을 사용해도 되지만
    //한번더 계산함으로 확실하게? 하고 싶어서 직접 아이템의 갯수를 더해서 체크를 했다
    //좋은 방식인가? 는 의문이 들긴하다
    func pagingAbleChecking(paingAble : PagingAbleModel , totalCount : Int) -> Bool {
        pagingCountSetting(totalCount: totalCount)
        return !paingAble.isEnd && paingAble.pageableCount >= totalCount
    }
    
}
