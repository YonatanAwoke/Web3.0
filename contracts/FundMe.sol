// SPDX-Lincense-Identifier:MIT

pragma solidity ^0.6.0;



// Get the latest ETH/USD price from chainlink price feed
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
	// safe math library check uint256 for integer overflows
    using SafeMathChainlink for uint256;
    
    //mapping to store which address depositeded how much ETH
    mapping(address => uint256) public addressToAmountFunded;
    // array of addresses who deposited
    address[] public funders;
    //address of the owner (who deployed the contract)
    address public owner;
    
    // the first person to deploy the contract is
    // the owner
    constructor() public {
        owner = msg.sender;
    }
    
    function fund() public payable {
    	// 18 digit number to be compared with donated amount 
        uint256 minimumUSD = 50 * 10 ** 18;
        // //is the donated amount less than 50USD?
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");
        //if not, add to mapping and funders array
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    
    //function to get the version of the chainlink pricefeed
    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x20c13A1BfDE890e91a5b08CcCe421E2fdd4E1E2a);
        return priceFeed.version();
    }
    
    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x20c13A1BfDE890e91a5b08CcCe421E2fdd4E1E2a);
        (,int256 answer,,,) = priceFeed.latestRoundData();
         // ETH/USD rate in 18 digit 
         return uint256(answer * 10000000000);
    }
        function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }


    function withdraw() payable public {
        
        msg.sender.transfer(address(this).balance);

        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder]=0;
        }
        funders = new address[](0);
    }
}