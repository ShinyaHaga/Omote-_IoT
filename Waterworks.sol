pragma solidity 0.5.10;

contract Waterworks {
    
    address public owner;
    uint256 public basic_charge;
    uint256 public exceedance_money;
    mapping (address => bool) public is_started_water;
    mapping (address => uint256) public amount_of_water;
    mapping (address => uint256) public carryover_maney;
    mapping (address => uint256) public carryover_counter;
    mapping (address => bool) public is_not_paid;
    mapping (address => uint256[]) public history;
    mapping (address => uint256) public start_month;
    
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
        is_started_water[_useraddress] = true;
    }
    
    //水道料金の計算
    function calcCharge() public returns (uint) {
        uint256 charge;
        charge = (basic_charge + calcCommodityCharge(amount_of_water[msg.sender])) * 108 / 100;
        return charge;
    }
    
    //従量料金の計算
    function calcCommodityCharge(uint _amount_of_water) public returns (uint){
        return (_amount_of_water - 10) * exceedance_money;
    }
    
    //履歴を返す
    function getHistory() public view returns (uint[] memory, uint) {
        uint256 array_length = history[msg.sender].length;
        uint256[] memory arrayMemory = new uint256[](array_length);
        arrayMemory = history[msg.sender];
        return (arrayMemory, start_month[msg.sender]);
    }
    
    //水道を止める
    function stopSupply() public onlyOwner {
        if (carryover_counter[msg.sender] >= 3) {
            is_started_water[msg.sender] = false;
        }
    }
}










