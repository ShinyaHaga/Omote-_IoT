pragma solidity 0.5.10;

contract Waterworks {
    
    address public owner;
    uint256 public basic_charge;
    uint256 public exceedance_money;
    mapping (address => MemberStatus) public member;
    
    struct MemberStatus {
        uint256 start_month;
        bool is_supplied;
        uint256 amount_of_water;
        uint256 carryover_maney;
        uint256 carryover_counter;
        bool is_not_paid;
        uint256[] history;
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
    
    //水道料金の計算
    function calcCharge() public returns (uint) {
        uint256 charge;
        charge = (basic_charge + calcCommodityCharge(member[msg.sender].amount_of_water)) * 108 / 100;
        return charge;
    }
    
    //従量料金の計算
    function calcCommodityCharge(uint _amount_of_water) public returns (uint){
        return (_amount_of_water - 10) * exceedance_money;
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
        if (member[msg.sender].carryover_counter >= 3) {
            member[msg.sender].is_supplied = false;
        }
    }
}







