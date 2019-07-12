pragma solidity ^0.5.1;

contract HagaCoin {
    string public name;
    string public symbol;
    int8 public decimals;
    uint256 public totalsupply;
    mapping (address => uint256[]) public register;
    mapping (address => uint256) public balanceof;
    address public owner;
    
    modifier onlyOwner(){
        if(msg.sender != owner) revert();
        _;
    }
    
    event Transfer(address indexed from , address indexed to, uint256 value);
    
    constructor (string memory _name, string memory _symbol, int8 _decimals, uint256 _supply) public{
        balanceof[msg.sender] = _supply;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalsupply = _supply;
        owner = msg.sender;
    }
    
    //特定の人にトークンを送信
    function sendValue (uint256 _value, address _user)public onlyOwner{
        if(balanceof[owner] < _value)revert();
        if(balanceof[_user] + _value < balanceof[_user])revert();

        balanceof[owner] -= _value;
        balanceof[_user] += _value;
        
    }
    
    //支払い
    function payment (uint256 _amountOfWater, address _user)public{
        
        //水道料金の計算(水の量×従量料金+基本料金)
        uint256 W_bill = _amountOfWater*1000 + 2000;
        
        if(balanceof[_user] < W_bill)revert();
        if(balanceof[_user] + W_bill < balanceof[_user]) revert();
        
        balanceof[owner] += W_bill;
        balanceof[_user] -= W_bill;
        //支払い情報を配列に格納
        register[_user].push(W_bill);
        
    }
    
    //残高を所得
    function getbalance(address _user) public view returns(uint256){
        return balanceof[_user];
    }
    
    //支払い情報を配列から取り出す
    function getRegister(address _user) public view returns(uint256[] memory){
        uint256 array_length = register[_user].length;
        uint256[] memory arrayMemory = new uint256[](array_length);
        arrayMemory = register[_user];
        return arrayMemory;
    }
}