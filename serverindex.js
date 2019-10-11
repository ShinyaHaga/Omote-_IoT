if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
    ethereum.enable()
    web3.version.getNetwork((error, result) => {
        $('#networkid').text('Network ID: '+result)
    })
    var account;
    web3.eth.getAccounts((error, result) => {
        $('#accouns').text('Your accounts: '+result)
        account = result[0]
    })
} else {
    document.write('Install <a href="https://metamask.io">METAMASK</a>')
}

var name,address,tel,mail,youraccount;
var d=new $.Deferred;
async function Resist(){
      name=myEscape(document.forms[0].elements[0].value);
      address=myEscape(document.forms[0].elements[1].value);
      tel=myEscape(document.forms[0].elements[2].value);
      mail=myEscape(document.forms[0].elements[3].value);
      account=myEscape(document.forms[0].elements[4].value);
      d.resolve();
    //then($('.list').text('登録する個人情報は'+name+','+address+','+tel+','+mail+','+account+'です'))
}
d.promise().then(function(){
  //document.getElementById("list").innerHTML="登録する個人情報は"+name+","+address+","+tel+","+mail+","+account+"です";
  $('#list').text('登録する個人情報は'+name+','+address+','+tel+','+mail+','+account+'です')
});

var myEscape = function (str) {
    return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
};
