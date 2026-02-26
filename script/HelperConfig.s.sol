// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/FundMe.sol";
import "../src/PriceConverter.sol";

contract HelperConfig {
    struct NetworkConfig {
        address priceFeed;
    }
    NetworkConfig private currentChainNetworkConfig;
    constructor() {
        if (block.chainid == 1) {
            currentChainNetworkConfig = NetworkConfig({
                priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
            });
        }
        else if (block.chainid == 11155111) {
            currentChainNetworkConfig = NetworkConfig({
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
        }
        else if (block.chainid == 31337){
            currentChainNetworkConfig = NetworkConfig({
                priceFeed: createAnvilEthConfig()
            });
        }
    }

    function createAnvilEthConfig() public returns (address) {
        
    }
}