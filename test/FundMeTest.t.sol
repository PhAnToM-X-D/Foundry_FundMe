// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import "../src/PriceConverter.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract FundMeTest is Test {
    using PriceConverter for uint256;
    FundMe fundme;
    HelperConfig helperConfig;
    uint256 constant VALUE = 1e18;
    address constant USER = address(1);

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        (fundme, helperConfig) = deploy.run();
    }

    function testminusd() public view {
        uint256 expected = 5 * 1e18;
        assertEq(fundme.getminAmountThatCanBeFundedInUSD(), expected);
    }

    function testConversionRate() public view {
        uint256 eth = 1 ether;
        assertEq(eth.getConversionRate(fundme.returnPriceFeedAddress()), fundme.getConversionRateFor1());
    }
    
    function testfunder1() public {
        vm.deal(USER, 10 ether);
        vm.startPrank(USER);
        fundme.fund{value: VALUE}();
        vm.stopPrank();
        assertEq(fundme.funders(0),USER);
        assertEq(fundme.addressToAmountFunded(USER),VALUE);
        assertEq(fundme.getAmountInContractInUSD(),VALUE.getConversionRate(fundme.returnPriceFeedAddress()));
    }
}
