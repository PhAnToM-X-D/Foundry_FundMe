// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract FundMeTest is Test {
    FundMe fundme;
    HelperConfig helperConfig;

    function setup() external {
        DeployFundMe deploy = new DeployFundMe();
        (fundme, helperConfig) = deploy.run();
    }

    function testminusd () external view {
        uint256 expected = 5 * 1e18;
        assertEq(fundme.getminAmountThatCanBeFundedInUSD(), expected);
    }
}
