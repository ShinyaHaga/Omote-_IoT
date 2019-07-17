pragma solidity 0.5.10;

contract Waterworks {
    
    address public owner;
    uint256 public collected_money;//集金の総額
    uint256 public basic_charge;
    uint256 public exceedance_money;
    mapping (address => MemberStatus) public member;
    
    struct MemberStatus {
        uint256 start_month;//使用開始月
        bool is_supplied;//使用中であるかどうか
        uint256 amount_of_water;//当月の使用量
        uint256 carryover_money;
        uint256 not_pay_counter;//未払い回数
        uint256 payment_amount;//支払い金額の合計
        bool is_not_paid;
        uint256[] history;//使用量の履歴
    }
    
    modifier onlyOwner(){
        if(msg.sender != owner) revert();
        _;
    }
    
    constructor() public {
        owner = msg.sender;
        basic_charge = 500;
    }
    
    //水道サービスを開始する（オーナーが実行）
    function startService(address _useraddress) public onlyOwner {
        member[_useraddress].is_supplied = true;
    }
    
    //支払い料金の計算
    function calcPaymentAmount() public returns (uint) {
        member[msg.sender].payment_amount = calcCharge();
        return  member[msg.sender].payment_amount;
    }
    
    //水道料金の計算
    function calcCharge() public returns (uint charge) {
        charge = (basic_charge + calcCommodityCharge(member[msg.sender].amount_of_water)) * 108 / 100;
        return charge;
    }
    
    //従量料金の計算
    function calcCommodityCharge(uint _amount_of_water) public returns (uint) {
        return (_amount_of_water - 10) * exceedance_money;
    }
    
    //水道料金の支払い
    function payment() public payable {
        if(member[msg.sender].payment_amount != msg.value) revert();
        collected_money += msg.value;
        member[msg.sender].not_pay_counter = 0;
    }
    
    //使用水量の登録
    function setAmountOfWater(uint _amount_of_water) public returns (uint){
        member[msg.sender].amount_of_water = _amount_of_water;
        member[msg.sender].history.push(_amount_of_water);
        member[msg.sender].not_pay_counter++;
        return calcPaymentAmount();
    }
    
    //履歴を返す
    function getHistory() public view returns (uint[] memory, uint) {
        uint256 array_length = member[msg.sender].history.length;
        uint256[] memory arrayMemory = new uint256[](array_length);
        arrayMemory = member[msg.sender].history;
        return (arrayMemory, member[msg.sender].start_month);
    }
    
    //水道を止める
    function stopSupply() public onlyOwner {
        if (member[msg.sender].not_pay_counter >= 3) {
            member[msg.sender].is_supplied = false;
        }
    }
}


