// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import "../src/FundMe.sol";
import "../src/PriceConverter.sol";
import {MockV3Aggregator} from "./MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed;
    }
    NetworkConfig private currentChainNetworkConfig;
    error Invalid_chainId();

    constructor() {
        if (block.chainid == 1) {
            currentChainNetworkConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        } else if (block.chainid == 11155111) {
            currentChainNetworkConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        } else if (block.chainid == 31337) {
            currentChainNetworkConfig = NetworkConfig({priceFeed: createAnvilEthConfig()});
        } else {
            revert Invalid_chainId();
        }
    }

    function getNetworkConfig() public view returns (NetworkConfig memory) {
        return currentChainNetworkConfig;
    }

    function getChainId() public view returns (uint256) {
        return block.chainid;
    }

    function createAnvilEthConfig() public returns (address) {
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();
        return address(mockPriceFeed);
    }
}
